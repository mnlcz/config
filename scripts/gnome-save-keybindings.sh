#!/bin/bash

DIR="$CONFIG_DIR/wm/mutter"

dconf dump /org/gnome/desktop/wm/keybindings/ > "$DIR/wm-keybindings.conf"
dconf dump /org/gnome/shell/keybindings/ > "$DIR/shell-keybindings.conf"

echo "Keybindings saved."
