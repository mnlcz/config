(use-modules (guix gexp)
             (gnu home)
             (gnu home services)
             (gnu home services mcron)
             (gnu home services desktop)
             (gnu home services shepherd)
             (gnu packages)
             (gnu packages admin)
             (gnu packages base)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages freedesktop)
             (gnu packages fonts)
             (gnu packages gdb)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages gnupg)
             (gnu packages gnuzilla)
             (gnu packages groff)
             (gnu packages image-viewers)
             (gnu packages linux)
             (gnu packages password-utils)
             (gnu packages pdf)
             (gnu packages rust-apps)
             (gnu packages shells)
             (gnu packages terminals)
             (gnu packages version-control)
             (gnu packages video)
             (gnu packages vim)
             (gnu packages xdisorg)
             (gnu packages xfce)
             (gnu packages xorg)
             (gnu services)
             (mnlcz packages wio))

(define my-home-env
  '(("GBM_BACKEND" . "nvidia-drm") ("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
    ("LIBVA_DRIVER_NAME" . "nvidia")
    ("WLR_NO_HARDWARE_CURSORS" . "1")
    ("PKG_CONFIG_PATH" . "$HOME/.local/lib/pkgconfig")
    ("ZATHURA_PLUGINS_PATH" . "$HOME/.guix-home/profile/lib/zathura")
    ("PATH" . "$HOME/.local/bin:$PATH")
    ("XKB_DEFAULT_LAYOUT" . "latam")
    ("XKB_DEFAULT_VARIANT" . "deadtilde")))

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

                (service home-shepherd-service-type
                         (home-shepherd-configuration (services (list (shepherd-service
                                                                       (provision '
                                                                        (wio-clip-bridge))
                                                                       (start #~
                                                                              (make-forkexec-constructor
                                                                               (list #$
                                                                                (string-append
                                                                                 (getenv
                                                                                  "HOME")
                                                                                 "/Projects/config/wm/wio/wio-clip-bridge.scm"))
                                                                               #:log-file
                                                                               (string-append
                                                                                (getenv
                                                                                 "HOME")
                                                                                "/.local/state/wio-clip-bridge.log")))
                                                                       (stop #~
                                                                             (make-kill-destructor))
                                                                       (respawn?
                                                                        #t))))))

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
             icecat
             thunar
             mpv
	     swayimg
             zathura
             zathura-ps
             zathura-pdf-mupdf
             ;; fonts
             font-dejavu
             ;; tools
             bat
             binutils
             dbus
             fastfetch
             git
             gnupg
             groff
             gvfs
	     inotify-tools
             ncspot
             password-store
             pinentry
             rc
             tree
             wl-clipboard)))
