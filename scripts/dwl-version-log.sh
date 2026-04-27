#!/bin/sh
VERSIONS_FILE="$CONFIG_DIR/wm/dwl/VERSIONS"

{
    echo "dwl: $(dwl -v 2>&1)"
    echo "dwlb: $(dwlb -v 2>&1)"
    echo "bemenu: $(bemenu --version)"
    echo "fcft: $(pkg-config --modversion fcft)"
    echo "wlroots: $(pkg-config --modversion wlroots-0.18)"
    echo "Generated: $(date)"
} > "$VERSIONS_FILE"