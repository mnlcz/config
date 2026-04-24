#!/bin/bash

OS=$(grep "^NAME=" /etc/os-release)

if [ -n "$TMUX" ]; then
    exit 0
fi

if [[ -n "$SSH_CONNECTION" ]]; then
    exit 0
fi

# Create main session if it doesn't exist
if ! tmux has-session -t 'main' 2>/dev/null; then
    tmux new-session -d -s 'main'
    tmux send-keys -t main 'cd ~ ; clear ; fastfetch -c $CONFIG_DIR/tools/fastfetch/medium.jsonc ; $CONFIG_DIR/scripts/src/updates.php' Enter
    tmux new-window -t main -n "ssh"
    tmux new-window -t main -n 'podman'
    tmux send-keys -t main:podman 'cd $SOURCE_DIR ; clear ; podman ps -a' Enter
fi

# Create code session based on OS
if ! tmux has-session -t 'code' 2>/dev/null; then
    if [[ "$OS" == *"Fedora"* ]]; then
        tmux new-session -d -s 'code' -n "shell"
        tmux send-keys -t code:shell 'cd $SOURCE_DIR ; clear ; ls -lah' Enter
        tmux new-window -t code -n 'runner'
        tmux send-keys -t code:runner 'cd $SOURCE_DIR ; clear ; ls -lah' Enter
    else
        tmux new-session -d -s 'code' -n "shell"
        tmux send-keys -t code:shell 'cd $SOURCE_DIR ; clear ; x ls' Enter
        tmux new-window -t code -n 'editor'
        tmux send-keys -t code:editor 'cd $SOURCE_DIR ; clear ; echo "=== Editor ===" ; nvim -v | head -n 3 ; echo ; devinfo' Enter
        tmux new-window -t code -n 'runner'
        tmux send-keys -t code:runner 'cd $SOURCE_DIR ; clear ; x ls' Enter
    fi
fi

tmux select-window -t main:1
tmux attach-session -t main
