(use-modules (nonguix transformations)
             (guix channels)
             (gnu)
             (gnu system)
             (gnu packages package-management)
             (gnu packages shells)
             (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu system linux-initrd)
             (rnrs lists))
(use-service-modules networking ssh desktop base dbus)

(define my-channels
  (append (list (channel
                  (name 'mnlcz)
                  (url "file:///home/mnlcz/Projects/guix-channel")
                  (branch "main"))
                (channel
                  (name 'nonguix)
                  (url "https://gitlab.com/nonguix/nonguix")
                  (introduction
                   (make-channel-introduction
                    "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                    (openpgp-fingerprint
                     "2A39 3FFF 68F4 EF7A 3D29 12AF 6F51 20A0 22FB B2D5")))))
          %default-channels))

(define my-base-services
  (remove (lambda (service)
            (and (eq? (service-kind service) mingetty-service-type)
                 (equal? (mingetty-configuration-tty (service-value service))
                         "tty7"))) %base-services))

(define my-services
  (cons* (service openssh-service-type
                  (openssh-configuration (permit-root-login #f)
                                         (password-authentication? #t)))
         (service network-manager-service-type)
         (service wpa-supplicant-service-type)
         (service ntp-service-type)
         (service elogind-service-type)
         (service gpm-service-type)
         (service udisks-service-type)
         (service dbus-root-service-type)

         (service greetd-service-type
                  (greetd-configuration (greeter-supplementary-groups '("video"
                                                                        "input"))
                                        (terminals (list (greetd-terminal-configuration
                                                          (terminal-vt "7")
                                                          (terminal-switch #t)
                                                          (default-session-command
                                                           (greetd-user-session
                                                            (command (file-append
                                                                      (specification->package
                                                                       "tuigreet")
                                                                      "/bin/tuigreet"))
                                                            (command-args '("--time"
                                                                            "--remember"
                                                                            "--remember-session"
                                                                            "--sessions"
                                                                            "/usr/share/wayland-sessions"))
                                                            (xdg-session-type
                                                             "wayland"))))))))

         (modify-services my-base-services
           (guix-service-type config =>
                              (guix-configuration (inherit config)
                                                  (channels my-channels)
                                                  (guix (guix-for-channels
                                                         my-channels)))))))

(define %os
  (operating-system
    (locale "en_US.utf8")
    (timezone "America/Argentina/Buenos_Aires")
    (keyboard-layout (keyboard-layout "latam" "deadtilde"))
    (host-name "guix")

    (kernel linux)
    (initrd microcode-initrd)
    (firmware (list linux-firmware))
    (kernel-arguments (append '("modprobe.blacklist=eeepc_wmi")
                              %default-kernel-arguments))

    (users (cons* (user-account
                    (name "mnlcz")
                    (comment "MnLCz")
                    (group "users")
                    (shell (file-append rc "/bin/rc"))
                    (home-directory "/home/mnlcz")
                    (supplementary-groups '("wheel" "netdev" "audio" "video"
                                            "input"))) %base-user-accounts))

    (sudoers-file (plain-file "sudoers"
                              (string-append (plain-file-content
                                              %sudoers-specification)
                                             "mnlcz ALL = NOPASSWD: ALL\n")))

    (services
     my-services)

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
                           (type "ext4"))
                         (file-system
                           (mount-point "/mnt/windows")
                           (device (uuid "C81AA8F51AA8E224"
                                         'ntfs))
                           (type "ntfs3")
                           (create-mount-point? #t)
                           (options "uid=1000,gid=1000,windows_names")
                           (flags '(no-atime))
                           (mount-may-fail? #t))
                         (file-system
                           (mount-point "/mnt/hdd1")
                           (device (uuid "9064BAB664BA9E82"
                                         'ntfs))
                           (type "ntfs3")
                           (create-mount-point? #t)
                           (options "uid=1000,gid=1000")
                           (flags '(no-atime))
                           (mount-may-fail? #t))
                         (file-system
                           (mount-point "/mnt/hdd2")
                           (device (uuid "DC8E60758E6049DA"
                                         'ntfs))
                           (type "ntfs3")
                           (create-mount-point? #t)
                           (options "uid=1000,gid=1000")
                           (flags '(no-atime))
                           (mount-may-fail? #t)) %base-file-systems))))

((nonguix-transformation-nvidia #:driver nvda-580)
 %os)
