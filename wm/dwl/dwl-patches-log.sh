#!/bin/sh
PATCHES_FILE="$CONF/wm/dwl/PATCHES"

ls -1 /usr/local/src/dwl/patches | grep '\.patch' > "$PATCHES_FILE"