#!/bin/sh
PATCHES_FILE="$CONF/wm/dwl/dwlb/PATCHES"

ls -1 /usr/local/src/dwlb/patches | grep '\.patch' > "$PATCHES_FILE"
