#!/bin/sh
VERSIONS_FILE="$CONFIG_DIR/wm/dwl/VERSIONS"

meson_version() {
    grep "version:" "$1/meson.build" | head -n1 | grep -o "'[^']*'" | tr -d "'"
}

{
	echo "bemenu: $(bemenu --version)"
	echo "cliphist: $(cliphist version 2>&1 | head -n 1)"
    echo "dwl: $(dwl -v 2>&1)"
    echo "dwlb: $(dwlb -v 2>&1)"
	echo "fcft: $(pkg-config --modversion fcft)"
    echo "foot: $(foot -v)"
	echo "grim: $(meson_version /usr/local/src/grim)"
    echo "j4-dmenu-desktop: $(j4-dmenu-desktop --version)"
    echo "mako: $(meson_version /usr/local/src/mako)"
    echo "slurp: $(meson_version /usr/local/src/slurp)"   
    echo "wlroots: $(pkg-config --modversion wlroots-0.18)"
	echo "xsel: $(xsel --version)"
    echo "Generated: $(date)"
} > "$VERSIONS_FILE"
