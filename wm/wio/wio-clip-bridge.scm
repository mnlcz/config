#!/usr/bin/env -S guile -s
!#

(use-modules (ice-9 popen)
             (ice-9 rdelim)
             (ice-9 ftw)
             (ice-9 threads)
             (ice-9 match)
             (ice-9 format)
             (rnrs bytevectors)
             ((rnrs io ports)
              #:select (get-bytevector-all put-bytevector))
             (srfi srfi-1))

(define runtime-dir
  (or (getenv "XDG_RUNTIME_DIR") "/run/user/1000"))
(define poll-interval
  2)
(define suppress-window
  1)
; seconds to ignore a socket's own watcher after we push to it
(define primary-type
  "text/plain")

(define known
  (make-hash-table))
; socket -> #t
(define known-mutex
  (make-mutex))
(define suppressed-until
  (make-hash-table))
; socket -> time in seconds

(define (log fmt . args)
  (apply format
         (current-error-port)
         (string-append "[clip-bridge] " fmt "\n") args))

(define (wayland-sockets)
  (filter (lambda (f)
            (and (string-prefix? "wayland-" f)
                 (not (string-suffix? ".lock" f))))
          (or (scandir runtime-dir)
              '())))
(define (safely thunk . default)
  (catch #t thunk
         (lambda (key . args)
           (log "error: ~a ~a" key args)
           (if (pair? default)
               (car default) #f))))

(define (fetch sock)
  (safely (lambda ()
            (let* ((port (open-input-pipe (string-append "WAYLAND_DISPLAY="
                                                         sock " wl-paste -t '"
                                                         primary-type
                                                         "' 2>/dev/null")))
                   (bv (get-bytevector-all port)))
              (close-pipe port)
              (if (eof-object? bv) #f bv)))))

(define (push! sock bv)
  (hash-set! suppressed-until sock
             (+ (current-time) suppress-window))
  (safely (lambda ()
            (let ((port (open-output-pipe (string-append "WAYLAND_DISPLAY="
                                                         sock " wl-copy -t '"
                                                         primary-type "'"))))
              (put-bytevector port bv)
              (close-pipe port)))))

(define (propagate! from)
  (let ((bv (fetch from)))
    (when bv
      (with-mutex known-mutex
                  (hash-for-each (lambda (sock _)
                                   (unless (string=? sock from)
                                     (push! sock bv))) known)))))

(define (suppressed? sock)
  (let ((until (hash-ref suppressed-until sock)))
    (and until
         (< (current-time) until))))

(define (watch! sock)
  (log "watching ~a" sock)
  (with-mutex known-mutex
              (hash-set! known sock #t))
  (call-with-new-thread (lambda ()
                          (safely (lambda ()
                                    (let ((port (open-input-pipe (string-append
                                                                  "WAYLAND_DISPLAY="
                                                                  sock
                                                                  " wl-paste --watch echo tick 2>/dev/null"))))
                                      (let loop
                                        ()
                                        (let ((line (read-line port)))
                                          (unless (eof-object? line)
                                            (unless (suppressed? sock)
                                              (propagate! sock))
                                            (loop)))))) #f)
                          (log "lost socket ~a" sock)
                          (with-mutex known-mutex
                                      (hash-remove! known sock))
                          (hash-remove! suppressed-until sock))))

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
