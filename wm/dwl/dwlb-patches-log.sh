#!/bin/sh
PATCHES_FILE="$CONFIG_DIR/wm/dwl/dwlb/PATCHES"

ls -1 /usr/local/src/dwlb/patches | grep '\.patch' > "$PATCHES_FILE"
