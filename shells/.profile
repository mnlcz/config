# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# plan9port
export PLAN9=/home/mnlcz/Projects/plan9port
export PATH=$PATH:$PLAN9/bin

# Source environment modules
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/0dirs.sh ~/.bashrc.d/dev.sh ~/.bashrc.d/plan9.sh; do
        [ -f "$rc" ] && . "$rc"
    done
fi
