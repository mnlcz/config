#!/bin/sh

ACTION=$1
DEVICE=$2
USER_NAME="mnlcz"

ENV_FILE="/tmp/dwl-session-env"
[ -f "$ENV_FILE" ] || exit 1
. "$ENV_FILE"

case "$ACTION" in
    attach)
        su -m $USER_NAME -c \
        "DBUS_SESSION_BUS_ADDRESS='$DBUS_SESSION_BUS_ADDRESS' WAYLAND_DISPLAY='$WAYLAND_DISPLAY' XDG_RUNTIME_DIR='$XDG_RUNTIME_DIR' /usr/local/bin/notify-send -t 5000 'USB Connected' '$DEVICE attached'"
        ;;
    detach)
        su -m $USER_NAME -c \
        "DBUS_SESSION_BUS_ADDRESS='$DBUS_SESSION_BUS_ADDRESS' WAYLAND_DISPLAY='$WAYLAND_DISPLAY' XDG_RUNTIME_DIR='$XDG_RUNTIME_DIR' /usr/local/bin/notify-send -t 5000 'USB Disconnected' '$DEVICE removed'"
        ;;
esac