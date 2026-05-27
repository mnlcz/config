#!/bin/sh

# Don't run during display manager session setup
if [ -n "$XDG_SESSION_DESKTOP" ] && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ]; then
    exit 0
fi

OS=$(uname -s)

if [ -n "$TMUX" ]; then
    exit 0
fi

if [ -n "$SSH_CONNECTION" ]; then
    exit 0
fi

# Create main session if it doesn't exist
if ! tmux has-session -t 'main' 2>/dev/null; then
    tmux new-session -d -s 'main'
    tmux send-keys -t main 'cd ~ ; clear ; fastfetch -c $CONF/tools/fastfetch/medium.jsonc' Enter
    tmux new-window -t main -n "ssh"
    tmux new-window -t main -n 'podman'
    tmux send-keys -t main:podman 'cd $PROJ ; clear' Enter
fi

# Create code session if it doesn't exist
if ! tmux has-session -t 'code' 2>/dev/null; then
    case "$OS" in
        Linux)
            tmux new-session -d -s 'code' -n "shell"
            tmux send-keys -t code:shell 'cd $PROJ ; clear ; ls -lah' Enter
            tmux new-window -t code -n 'editor'
            tmux send-keys -t code:editor 'cd $PROJ ; clear ; echo "=== Editor ===" ; nvim -v | head -n 3 ; echo ; devinfo' Enter
            tmux new-window -t code -n 'runner'
            tmux send-keys -t code:runner 'cd $PROJ ; clear ; x ls' Enter
            ;;
        FreeBSD)
            tmux new-session -d -s 'code' -n "shell"
            tmux send-keys -t code:shell 'cd $PROJ ; clear ; ls -lah' Enter
            tmux new-window -t code -n 'editor'
            tmux send-keys -t code:editor 'cd $PROJ ; clear ; vis .' Enter
            tmux new-window -t code -n 'runner'
            tmux send-keys -t code:runner 'cd $PROJ ; clear ; ls -lah' Enter
            ;;
    esac
fi

tmux select-window -t main:1

# Only attach if it's an interactive terminal
if [ -t 1 ]; then
    tmux attach-session -t main
fi
