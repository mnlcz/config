(use-modules (nonguix transformations)
             (gnu)
             (gnu system)
             (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu system linux-initrd))
(use-service-modules networking ssh desktop base dbus)

(define %os
  (operating-system
    (locale "en_US.utf8")
    (timezone "America/Argentina/Buenos_Aires")
    (keyboard-layout (keyboard-layout "latam" "deadtilde"))
    (host-name "guix")

    (kernel linux)
    (initrd microcode-initrd)
    (firmware (list linux-firmware))

    (users (cons* (user-account
                    (name "mnlcz")
                    (comment "MnLCz")
                    (group "users")
                    (home-directory "/home/mnlcz")
                    (supplementary-groups '("wheel" "netdev" "audio" "video"
                                            "input"))) %base-user-accounts))

    (services
     (append (list (service openssh-service-type
                            (openssh-configuration (permit-root-login #f)
                                                   (password-authentication?
                                                    #t)))
                   (service network-manager-service-type)
                   (service wpa-supplicant-service-type)
                   (service ntp-service-type)
                   (service elogind-service-type)
                   (service gpm-service-type)
                   (service udisks-service-type)
                   (service dbus-root-service-type)
                   (service greetd-service-type
                            (greetd-configuration (greeter-supplementary-groups '
                                                   ("video" "input"))
                                                  (terminals (list (greetd-terminal-configuration
                                                                    (terminal-vt
                                                                     "7")
                                                                    (terminal-switch
                                                                     #t)
                                                                    (default-session-command
                                                                     (greetd-user-session
                                                                      (command
                                                                       (file-append
                                                                        (specification->package
                                                                         "tuigreet")
                                                                        "/bin/tuigreet"))
                                                                      (command-args '
                                                                       ("--time"
                                                                        "--remember"
                                                                        "--remember-session"
                                                                        "--sessions"
                                                                        "/usr/share/wayland-sessions"))
                                                                      (xdg-session-type
                                                                       "wayland")))))))))
             %base-services))

    (bootloader (bootloader-configuration
                  (bootloader grub-bootloader)
                  (targets (list "/dev/sdd"))
                  (keyboard-layout keyboard-layout)))

    (swap-devices (list (swap-space
                          (target (uuid "ed1f361e-2e1c-4e77-9ae4-cb9b48af1043")))))

    (file-systems (cons* (file-system
                           (mount-point "/")
                           (device (uuid
                                    "b9fd21a0-9853-4e8d-afa9-eb1e98fcf301"
                                    'ext4))
                           (type "ext4")) %base-file-systems))))

((nonguix-transformation-nvidia #:driver nvda-580)
 %os)
