#!/usr/bin/env -S guile -s
!#

;;; wio-clip-bridge --- sync clipboard (regular + primary selection) across
;;; wio's per-window cage instances via wlr-data-control-v1.
;;; Requires: cage patched with wlr_data_control_manager_v1_create
;;; Requires: wl-clipboard, inotify-tools on PATH

(use-modules (ice-9 popen)
             (ice-9 rdelim)
             (ice-9 ftw)
             (ice-9 textual-ports)
             (ice-9 threads)
             (ice-9 match)
             (ice-9 format)
             (rnrs bytevectors)
             ((rnrs io ports)
              #:select (get-bytevector-all put-bytevector))
             (srfi srfi-1)
             (srfi srfi-11))

;;; --- Configuration -----------------------------------------------------

(define runtime-dir
  (or (getenv "XDG_RUNTIME_DIR") "/run/user/1000"))
(define fallback-poll-interval
  30)
 ; seconds between safety-net rescans, in case inotify misses/dies
(define suppress-window
  1)
 ; seconds to ignore a selection's own echo, post-write
(define pre-write-guard
  0.2)
 ; seconds of guard suppression while a write is in flight

;; Off by default. Flip to #t only once you've validated the detection
;; logic below under real use -- a false positive here actively destroys
;; content on every other window, unlike every other feature so far.
(define propagate-clears?
  #t)

(define empty-clipboard-marker
  "Nothing is copied")

;; Priority order: first match wins. Images before text, since a text
;; fallback can't reconstruct an image but the common text aliases are
;; already covered by wl-copy's own auto-advertising once we pick one.
(define type-priority
  '("image/png" "image/jpeg"
    "text/plain;charset=utf-8"
    "text/plain"
    "STRING"
    "UTF8_STRING"
    "TEXT"))

;;; --- Shared state --------------------------------------------------------

(define known
  (make-hash-table))
 ; socket -> #t  (window still open)
(define known-mutex
  (make-mutex))
(define suppressed-until
  (make-hash-table))
 ; (sock . primary?) -> time, breaks propagation loops
(define watcher-count
  (make-hash-table))
 ; socket -> count of still-active watcher threads
(define watcher-count-mutex
  (make-mutex))
(define had-content
  (make-hash-table))
 ; (sock . primary?) -> #t once real content seen there

;;; --- Utilities -----------------------------------------------------------

(define log-mutex
  (make-mutex))
(define (log fmt . args)
  (with-mutex log-mutex
              (apply format
                     (current-error-port)
                     (string-append "[clip-bridge] " fmt "\n") args)))

(define (safely thunk . default)
  (catch #t thunk
         (lambda (key . args)
           (log "error: ~a ~a" key args)
           (if (pair? default)
               (car default) #f))))

(define (sel-key sock primary?)
  (cons sock primary?))

;; icecat/Firefox creates its own internal "wayland-proxy-<pid>" socket
;; (a connection-reliability buffer, not a real compositor endpoint) --
;; exclude it so we don't spawn watcher threads against something that
;; will never accept a clipboard connection.
(define (wayland-socket? f)
  (and (string-prefix? "wayland-" f)
       (not (string-suffix? ".lock" f))
       (not (string-prefix? "wayland-proxy-" f))))

(define (wayland-sockets)
  (filter wayland-socket?
          (or (scandir runtime-dir)
              '())))

;;; --- Safe subprocess helpers (plain pipes only, no raw fork) --------------

;; Runs `cmd` via a plain input pipe, returns its full text output (stdout,
;; unless the caller redirected stderr into stdout in `cmd` itself).
;; Never throws -- returns "" on any failure.
(define (pipe-text cmd)
  (safely (lambda ()
            (let* ((port (open-input-pipe cmd))
                   (text (get-string-all port)))
              (close-pipe port) text)) ""))

;;; --- Type resolution -------------------------------------------------------

;; Returns two values: (offered-types stderr-text). stderr-text is only
;; populated (via a second, cheap call) when nothing was offered, since
;; that's the only case where we need it for confirmed-empty? below.
(define (list-types+status sock primary?)
  (let* ((flag (if primary? "-p " ""))
         (types-text (pipe-text (string-append "WAYLAND_DISPLAY=" sock
                                               " wl-paste " flag
                                               "--list-types 2>/dev/null")))
         (offered (filter (negate string-null?)
                          (string-split types-text #\newline))))
    (if (null? offered)
        (let ((err-text (pipe-text (string-append "WAYLAND_DISPLAY=" sock
                                    " wl-paste " flag
                                    "--list-types 2>&1 1>/dev/null"))))
          (values offered err-text))
        (values offered ""))))

(define (preferred-type offered)
  (find (lambda (t)
          (member t offered)) type-priority))

;;; --- Selection read/write --------------------------------------------------

(define (fetch sock primary? type)
  (safely (lambda ()
            (let* ((flag (if primary? "-p " ""))
                   (port (open-input-pipe (string-append "WAYLAND_DISPLAY="
                                                         sock
                                                         " wl-paste "
                                                         flag
                                                         "-t '"
                                                         type
                                                         "' 2>/dev/null")))
                   (bv (get-bytevector-all port)))
              (close-pipe port)
              (if (eof-object? bv) #f bv)))))

(define (push! sock bv primary? type)
  ;; short guard while the write is actually happening
  (hash-set! suppressed-until
             (sel-key sock primary?)
             (+ (current-time) pre-write-guard))
  (safely (lambda ()
            (let* ((flag (if primary? "-p " ""))
                   (port (open-output-pipe (string-append "WAYLAND_DISPLAY="
                                                          sock
                                                          " wl-copy "
                                                          flag
                                                          "-t '"
                                                          type
                                                          "'"))))
              (put-bytevector port bv)
              (close-pipe port))))
  ;; real suppression window starts only once the write has completed
  (hash-set! suppressed-until
             (sel-key sock primary?)
             (+ (current-time) suppress-window))
  ;; the destination now genuinely holds content too
  (hash-set! had-content
             (sel-key sock primary?) #t))

;; Mirrors push!'s suppression pattern, but clears instead of writing.
(define (clear! sock primary?)
  (hash-set! suppressed-until
             (sel-key sock primary?)
             (+ (current-time) pre-write-guard))
  (safely (lambda ()
            (let* ((flag (if primary? "-p " ""))
                   (port (open-input-pipe (string-append "WAYLAND_DISPLAY="
                                           sock " wl-copy " flag
                                           "--clear 2>/dev/null"))))
              (get-string-all port)
              (close-pipe port))))
  (hash-set! suppressed-until
             (sel-key sock primary?)
             (+ (current-time) suppress-window))
  ;; the destination is now empty again, so its "had content" state resets too --
  ;; a subsequent empty tick on IT shouldn't re-propagate another clear
  (hash-remove! had-content
                (sel-key sock primary?)))

(define (suppressed? sock primary?)
  (let ((until (hash-ref suppressed-until
                         (sel-key sock primary?))))
    (and until
         (< (current-time) until))))

;; Conservative: only treated as a genuine clear if BOTH signals agree --
;; zero types offered AND wl-paste's own stderr explicitly says so.
;; Anything else (including outright command failure) is left alone.
(define (confirmed-empty? offered stderr-text)
  (and (null? offered)
       (string-contains stderr-text empty-clipboard-marker)))

(define (propagate! from primary?)
  (let-values (((offered err)
                (list-types+status from primary?)))
              (let ((type (preferred-type offered)))
                (cond
                  (type (let ((bv (fetch from primary? type)))
                          (when bv
                            (hash-set! had-content
                                       (sel-key from primary?) #t)
                            (with-mutex known-mutex
                                        (hash-for-each (lambda (sock _)
                                                         (unless (string=?
                                                                  sock from)
                                                           (push! sock bv
                                                                  primary?
                                                                  type)))
                                                       known)))))
                  ((confirmed-empty? offered err)
                   (if (hash-ref had-content
                                 (sel-key from primary?))
                       (begin
                         (log
                          "confirmed empty selection on ~a (primary? ~a), had prior content -- treating as a clear"
                          from primary?)
                         (hash-remove! had-content
                                       (sel-key from primary?))
                         (if propagate-clears?
                             (with-mutex known-mutex
                                         (hash-for-each (lambda (sock _)
                                                          (unless (string=?
                                                                   sock from)
                                                            (clear! sock
                                                                    primary?)))
                                                        known))
                             (log
                              "propagate-clears? is #f, not clearing downstream")))
                       (log
                        "empty selection on ~a (primary? ~a) but never had content -- ignoring"
                        from primary?)))
                  (else (log
                         "ambiguous/failed read on ~a (primary? ~a), stderr: ~a -- not acting"
                         from primary? err))))))

;;; --- Watcher lifecycle -----------------------------------------------------

(define (watcher-done! sock)
  (with-mutex watcher-count-mutex
              (let ((remaining (1- (hash-ref watcher-count sock 1))))
                (if (<= remaining 0)
                    (begin
                      (hash-remove! watcher-count sock)
                      (with-mutex known-mutex
                                  (hash-remove! known sock))
                      (log "socket ~a fully removed" sock))
                    (hash-set! watcher-count sock remaining)))))

(define (watch-selection! sock primary?)
  (let* ((flag (if primary? "-p " ""))
         (label (if primary? "primary" "regular")))
    (safely (lambda ()
              (let ((port (open-input-pipe (string-append "WAYLAND_DISPLAY="
                                            sock " wl-paste " flag
                                            "--watch echo tick 2>/dev/null"))))
                (let loop
                  ()
                  (let ((line (read-line port)))
                    (unless (eof-object? line)
                      (unless (suppressed? sock primary?)
                        (propagate! sock primary?))
                      (loop)))))) #f)
    (log "~a watcher ended for ~a" label sock)
    (hash-remove! suppressed-until
                  (sel-key sock primary?))
    ;; drop this socket/selection's history so a future reused socket
    ;; name doesn't inherit a previous, unrelated window's state
    (hash-remove! had-content
                  (sel-key sock primary?))
    (watcher-done! sock)))

(define (watch! sock)
  (log "watching ~a" sock)
  (with-mutex known-mutex
              (hash-set! known sock #t))
  (with-mutex watcher-count-mutex
              (hash-set! watcher-count sock 2))
  (call-with-new-thread (lambda ()
                          (watch-selection! sock #f)))
  (call-with-new-thread (lambda ()
                          (watch-selection! sock #t))))

(define (register-if-new! sock)
  (let ((already? (with-mutex known-mutex
                              (hash-ref known sock))))
    (unless already?
      (watch! sock))))

;;; --- Discovery: inotify-driven, with a slow polling safety net -----------

;; Long-lived thread: watches runtime-dir for newly created wayland-* socket
;; files via inotifywait and registers them the instant they appear, instead
;; of waiting on a polling cycle.
(define (watch-new-sockets!)
  (call-with-new-thread (lambda ()
                          (safely (lambda ()
                                    (let ((port (open-input-pipe (string-append
                                                                  "inotifywait -m -e create --format '%f' '"
                                                                  runtime-dir
                                                                  "' 2>/dev/null"))))
                                      (let loop
                                        ()
                                        (let ((line (read-line port)))
                                          (unless (eof-object? line)
                                            (when (wayland-socket? line)
                                              (register-if-new! line))
                                            (loop)))))) #f)
                          ;; if we ever get here, inotifywait exited -- not expected under
                          ;; normal operation. The fallback poll loop below keeps discovery
                          ;; working, just at reduced responsiveness, until this is noticed.
                          (log
                           "inotify watcher exited unexpectedly -- falling back to polling only"))))

;;; --- Main -------------------------------------------------------------

(setvbuf (current-error-port)
         'line)
(log "starting, watching ~a" runtime-dir)

;; Start the inotify watcher first, so events occurring during the initial
;; scan below aren't missed in the gap between "list current sockets" and
;; "start watching for new ones".
(watch-new-sockets!)

;; Initial scan: covers windows that were already open before the daemon
;; started -- inotify only reports events from this point forward, it has
;; no memory of what already existed.
(for-each register-if-new!
          (wayland-sockets))

;; Slow fallback rescan: safety net in case inotify misses an event or the
;; inotifywait process dies. Not the primary discovery path any more, so
;; the interval can be generous.
(let loop
  ()
  (sleep fallback-poll-interval)
  (for-each register-if-new!
            (wayland-sockets))
  (loop))

