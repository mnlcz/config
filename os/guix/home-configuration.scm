(use-modules (guix gexp)
             (gnu home)
             (gnu home services)
             (gnu home services shepherd)
             (gnu packages)
             (gnu packages admin)
             (gnu packages fonts)
             (gnu packages freedesktop)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages gnupg)
             (gnu packages gnuzilla)
             (gnu packages password-utils)
             (gnu packages rust-apps)
             (gnu packages shells)
             (gnu packages terminals)
             (gnu packages version-control)
             (gnu packages xdisorg)
             (gnu packages xfce)
             (gnu packages xorg)
             (gnu services)
             (mnlcz packages hevel)
             (mnlcz packages neuswc))

(home-environment
  (services
   (append (list (simple-service 'nvidia-wayland-env
                                 home-environment-variables-service-type
                                 '(("GBM_BACKEND" . "nvidia-drm")
                                   ("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
                                   ("LIBVA_DRIVER_NAME" . "nvidia")
                                   ("XDG_SESSION_TYPE" . "wayland")
                                   ("WLR_NO_HARDWARE_CURSORS" . "1")
                                   ("PKG_CONFIG_PATH" . "$HOME/.local/lib/pkgconfig")
                                   ("PATH" . "$HOME/.local/bin:$PATH")
                                   ("XKB_DEFAULT_LAYOUT" . "latam")
                                   ("XKB_DEFAULT_VARIANT" . "deadtilde")
                                   ("DBUS_SESSION_BUS_ADDRESS" . "unix:path=/run/user/1000/bus")))
                 (simple-service 'gvfs-daemons home-shepherd-service-type
                                 (list (shepherd-service (provision '(dbus-session))
                                                         (requirement '())
                                                         (start #~(make-forkexec-constructor '
                                                                   (#$(file-append
                                                                       dbus
                                                                       "/bin/dbus-daemon")
                                                                    "--session"
                                                                    "--address=unix:path=/run/user/1000/bus"
                                                                    "--nofork"
                                                                    "--print-address")))
                                                         (stop #~(make-kill-destructor)))
                                       (shepherd-service (provision '(gvfs))
                                                         (requirement '(dbus-session))
                                                         (start #~(make-forkexec-constructor '
                                                                   (#$(file-append
                                                                       gvfs
                                                                       "/libexec/gvfsd"))))
                                                         (stop #~(make-kill-destructor)))
                                       (shepherd-service (provision '(gvfs-udisks2))
                                                         (requirement '(gvfs))
                                                         (start #~(make-forkexec-constructor '
                                                                   (#$(file-append
                                                                       gvfs
                                                                       "/libexec/gvfs-udisks2-volume-monitor"))))
                                                         (stop #~(make-kill-destructor))))))
           %base-home-services))

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
             hevel
             neuswc
             ;; programs
             havoc
             icecat
             thunar
             ;; fonts
             font-dejavu
             ;; tools
             bat
             dbus
             gvfs
             gnupg
             pinentry
             password-store
             rc
             tree
             wl-clipboard
             git)))
