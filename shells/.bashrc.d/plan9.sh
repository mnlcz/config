# OLD WAY OF LAUNCHING ACME. CHECK scripts/launch-acme.sh instead
# Requires fusermount (or fusermount3 aliased) with user_allow_other uncommented in /etc/fuse.conf
acme() {
    # clean stale mounts
    fusermount -u /mnt/acme 2>/dev/null
    fusermount -u /mnt/font 2>/dev/null
    mkdir -p /mnt/acme /mnt/font
    # sudo chown $(whoami): /mnt/acme /mnt/font

    # start font server if not running
    if ! pgrep -x fontsrv > /dev/null; then
        fontsrv -m /mnt/font &
        # Wait until font mount is ready
        timeout 5 sh -c 'until ls /mnt/font/* 2>/dev/null | grep -q .; do sleep 0.1; done'
    fi

    export NAMESPACE=${NAMESPACE:-$($PLAN9/bin/namespace)}

    # start plumber if not running
    if ! pgrep -x plumber >/dev/null; then
        echo "[acme] starting plumber..."
        $PLAN9/bin/plumber &
        sleep 0.5
    fi

    # load plumbing rules
    cat $PLAN9/plumb/basic | $PLAN9/bin/9p write plumb/rules

    # launch acme 
    SHELL=$PLAN9/bin/rc \
    $PLAN9/bin/acme -m /mnt/acme -f /mnt/font/RedHatMono-Regular/13a/font "$@" &
}
