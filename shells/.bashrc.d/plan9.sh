# Requires fusermount (or fusermount3 aliased) with user_allow_other uncommented in /etc/fuse.conf
acme() {
    # mkdir -p /mnt/acme ; sudo chown $(whoami): /mnt/acme
    # mkdir -p /mnt/font ; sudo chown $(whoami): /mnt/font
    fontsrv -m /mnt/font &
    sleep 1 # give fontsrv a moment to start
    SHELL=$PLAN9/bin/rc $PLAN9/bin/acme -m /mnt/acme -f /mnt/font/RedHatMono-Regular/13a/font "$@" &
}
