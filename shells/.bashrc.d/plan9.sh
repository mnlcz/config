# Requires fusermount (or fusermount3 aliased) with user_allow_other uncommented in /etc/fuse.conf
acme() {
    # mkdir -p /mnt/acme
    $PLAN9/bin/acme -m /mnt/acme "$@" &
}
