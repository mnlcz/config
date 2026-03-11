#!/bin/bash

DIR="$CONFIG_DIR/wm/mutter"

dconf load /org/gnome/desktop/wm/keybindings/ < "$DIR/wm-keybindings.conf"
dconf load /org/gnome/shell/keybindings/ < "$DIR/shell-keybindings.conf"

echo "Keybindings restored."
