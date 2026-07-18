#!/usr/bin/env -S guile -s
!#

;;; wio-clip-bridge --- sync clipboard (regular + primary selection) across
;;; wio's per-window cage instances via wlr-data-control-v1.
;;; Requires: cage patched with wlr_data_control_manager_v1_create
;;; Requires: wl-clipboard on PATH

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
             (srfi srfi-1))

;;; --- Configuration -----------------------------------------------------

(define runtime-dir
  (or (getenv "XDG_RUNTIME_DIR") "/run/user/1000"))
(define poll-interval
  2)
 ; seconds between new-socket discovery scans
(define suppress-window
  1)
 ; seconds to ignore a selection's own echo, post-write
(define pre-write-guard
  0.2)
 ; seconds of guard suppression while a write is in flight

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

;;; --- Utilities -----------------------------------------------------------

(define (log fmt . args)
  (apply format
         (current-error-port)
         (string-append "[clip-bridge] " fmt "\n") args))

(define (safely thunk . default)
  (catch #t thunk
         (lambda (key . args)
           (log "error: ~a ~a" key args)
           (if (pair? default)
               (car default) #f))))

(define (sel-key sock primary?)
  (cons sock primary?))

(define (wayland-sockets)
  (filter (lambda (f)
            (and (string-prefix? "wayland-" f)
                 (not (string-suffix? ".lock" f))))
          (or (scandir runtime-dir)
              '())))

;;; --- Type resolution -------------------------------------------------------

(define (list-types sock primary?)
  (safely (lambda ()
            (let* ((flag (if primary? "-p " ""))
                   (port (open-input-pipe (string-append "WAYLAND_DISPLAY="
                                           sock " wl-paste " flag
                                           "--list-types 2>/dev/null")))
                   (text (get-string-all port)))
              (close-pipe port)
              (filter (negate string-null?)
                      (string-split text #\newline))))
          '()))

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
             (+ (current-time) suppress-window)))

(define (suppressed? sock primary?)
  (let ((until (hash-ref suppressed-until
                         (sel-key sock primary?))))
    (and until
         (< (current-time) until))))

(define (propagate! from primary?)
  (let* ((offered (list-types from primary?))
         (type (preferred-type offered)))
    (when type
      (let ((bv (fetch from primary? type)))
        (when bv
          (with-mutex known-mutex
                      (hash-for-each (lambda (sock _)
                                       (unless (string=? sock from)
                                         (push! sock bv primary? type))) known)))))))

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

;;; --- Main loop -------------------------------------------------------------

(log "starting, watching ~a" runtime-dir)
(let loop
  ()
  (for-each (lambda (s)
              (unless (with-mutex known-mutex
                                  (hash-ref known s))
                (watch! s)))
            (wayland-sockets))
  (sleep poll-interval)
  (loop))

