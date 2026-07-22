(use-modules (guix gexp)
             (gnu home)
             (gnu home services)
             (gnu home services mcron)
             (gnu home services desktop)
             (gnu home services shepherd)
             (gnu packages)
             (gnu packages admin)
             (gnu packages base)
             (gnu packages chromium)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages freedesktop)
             (gnu packages fonts)
             (gnu packages gdb)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages gnupg)
             (gnu packages groff)
             (gnu packages image-viewers)
             (gnu packages linux)
             (gnu packages password-utils)
             (gnu packages pdf)
             (gnu packages plan9)
             (gnu packages rust-apps)
             (gnu packages shells)
             (gnu packages terminals)
             (gnu packages textutils)
             (gnu packages version-control)
             (gnu packages video)
             (gnu packages vim)
             (gnu packages xdisorg)
             (gnu packages xfce)
             (gnu packages xorg)
             (gnu services)
             (mnlcz packages wio))

(define my-path
  (string-join '("$HOME/.local/bin" "$HOME/.guix-home/profile/bin"
                 "$HOME/.guix-home/profile/plan9/bin" "$PATH") ":"))

(define my-home-env
  `(("GBM_BACKEND" . "nvidia-drm") ("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
    ("LIBVA_DRIVER_NAME" . "nvidia")
    ("WLR_NO_HARDWARE_CURSORS" . "1")
    ("PKG_CONFIG_PATH" . "$HOME/.local/lib/pkgconfig")
    ("ZATHURA_PLUGINS_PATH" . "$HOME/.guix-home/profile/lib/zathura")
    ("XKB_DEFAULT_LAYOUT" . "latam")
    ("XKB_DEFAULT_VARIANT" . "deadtilde")
    ("PLAN9" . "$HOME/.guix-home/profile/plan9")
    ("NAMESPACE" . "/tmp/ns.mnlcz")
    ("PATH" unquote my-path)))

(define (make-symlink-service name source rel-target)
  (simple-service name home-activation-service-type
                  #~(begin
                      (use-modules (guix build utils))
                      (let ((target (string-append (getenv "HOME") "/"
                                                   #$rel-target)))
                        (when (or (file-exists? target)
                                  (false-if-exception (lstat target)))
                          (delete-file target))
                        (symlink #$source target)))))

(define my-shepherd-services
  (list (shepherd-service (provision '(plan9-namespace))
                          (one-shot? #t)
                          (start #~(lambda _
                                     (unless (file-exists? "/tmp/ns.mnlcz")
                                       (mkdir "/tmp/ns.mnlcz"))
                                     (chmod "/tmp/ns.mnlcz" #o700) #t))
                          (documentation
                           "Ensure the plan9port namespace directory exists."))

        (shepherd-service (provision '(plumber))
                          (requirement '(plan9-namespace))
                          (start #~(make-forkexec-constructor (list (string-append
                                                                     (getenv
                                                                      "PLAN9")
                                                                     "/bin/plumber")
                                                                    "-f")))
                          (stop #~(make-kill-destructor))
                          (respawn? #t))

        (shepherd-service (provision '(wio-clip-bridge))
                          (start #~(make-forkexec-constructor (list #$(string-append
                                                                       (getenv
                                                                        "HOME")
                                                                       "/Projects/config/wm/wio/wio-clip-bridge.scm"))
                                                              #:log-file (string-append
                                                                          (getenv
                                                                           "HOME")
                                                                          "/.local/state/wio-clip-bridge.log")))
                          (stop #~(make-kill-destructor))
                          (respawn? #t))))

(define my-home-services
  (append (list (simple-service 'nvidia-wayland-env
                                home-environment-variables-service-type
                                my-home-env)
                (service home-dbus-service-type)

                (make-symlink-service 'rcrc-symlink
                 "/home/mnlcz/Projects/config/shells/.rcrc" ".rcrc")
                (make-symlink-service 'havoc-symlink
                 "/home/mnlcz/Projects/config/term/havoc" ".config/havoc")
                (make-symlink-service 'mpv-symlink
                                      "/home/mnlcz/Projects/config/tools/mpv"
                                      ".config/mpv")
                (make-symlink-service 'emacs-init-symlink
                 "/home/mnlcz/Projects/config/editor/emacs" ".config/emacs")
                (make-symlink-service 'acme-run-symlink
                 "/home/mnlcz/Projects/config/editor/acme/acme.run"
                 ".local/bin/acme")
                (make-symlink-service 'plumbing-symlink
                 "/home/mnlcz/Projects/config/editor/acme/plumbing"
                 "lib/plumbing")

                (service home-shepherd-service-type
                         (home-shepherd-configuration (services
                                                       my-shepherd-services)))

                (service home-mcron-service-type
                         (home-mcron-configuration (jobs (list #~(job '(next-minute '
                                                                        (0))
                                                                  (lambda ()
                                                                    (let* ((log
                                                                            (string-append
                                                                             (getenv
                                                                              "HOME")
                                                                             "/.local/state/wio-clip-bridge.log"))
                                                                           (rotated
                                                                            (string-append
                                                                             log
                                                                             ".1")))
                                                                      (when (file-exists?
                                                                             log)
                                                                        (copy-file
                                                                         log
                                                                         rotated)
                                                                        (call-with-output-file log
                                                                          (lambda 
                                                                                  (port)
                                                                            #t)))))
                                                                  "rotate-wio-clip-bridge-log")))))

                )

          %base-home-services))

(home-environment
  (services
   my-home-services)

  (packages (list
             ;; graphics
             wayland
             wayland-protocols
             libinput
             libdrm
             pixman
             libxkbcommon
             libxcb
             xcb-util-wm
             xorg-server-xwayland
             ;; compositor
             wio
             ;; dev
             emacs-pgtk ;bare emacs package doesn't work fine
             emacs-geiser
             emacs-geiser-guile
             emacs-guix
             gdb
             just
             typst
             typstyle
             vim
             ;; programs
             havoc
             thunar
             mpv
             swayimg
             ungoogled-chromium
             zathura
             zathura-ps
             zathura-pdf-mupdf
             ;; fonts
             font-dejavu
             ;; tools
             bat
             binutils
             btop
             dbus
             fastfetch
             ffmpegthumbnailer
             git
             gnupg
             groff
             gvfs
             inotify-tools
             ncspot
             password-store
             pinentry
             plan9port
             rc
             tldr
             tree
             wl-clipboard)))
