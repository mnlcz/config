#!/bin/sh
VERSIONS_FILE="$CONFIG_DIR/wm/dwl/VERSIONS"

meson_version() {
    grep "version:" "$1/meson.build" | head -n1 | grep -o "'[^']*'" | tr -d "'"
}

{
    echo "dwl: $(dwl -v 2>&1)"
    echo "dwlb: $(dwlb -v 2>&1)"
    echo "bemenu: $(bemenu --version)"
    echo "j4-dmenu-desktop: $(j4-dmenu-desktop --version)"
    echo "mako: $(meson_version /usr/local/src/mako)"
    echo "grim: $(meson_version /usr/local/src/grim)"
    echo "slurp: $(meson_version /usr/local/src/slurp)"
    echo "fcft: $(pkg-config --modversion fcft)"
    echo "wlroots: $(pkg-config --modversion wlroots-0.18)"
    echo "Generated: $(date)"
} > "$VERSIONS_FILE"