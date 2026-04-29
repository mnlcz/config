#!/bin/sh
PATCHES_FILE="$CONFIG_DIR/wm/dwl/PATCHES"

ls -1 /usr/local/src/dwl/patches | grep '\.patch' > "$PATCHES_FILE"