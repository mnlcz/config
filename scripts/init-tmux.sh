#!/bin/bash

if [ -n "$TMUX" ]; then
    exit 0
fi

# main session
if tmux has-session -t 'main' 2>/dev/null; then
    tmux attach-session -t main
else
    tmux new-session -d -s 'main' #-n 'bash'
    tmux send-keys -t main:bash 'cd ~' Enter
fi

# dev session
if ! tmux has-session -t 'code' 2>/dev/null; then
    tmux new-session -d -s 'code' -n "shell"
    tmux send-keys -t code:shell 'cd $SOURCE_DIR ; x ls' Enter
    # 2nd window
    tmux new-window -t code -n 'runner'
    tmux send-keys -t code:runner 'cd $SOURCE_DIR ; x ls' Enter
    # 3rd window
    tmux new-window -t code -n 'podman'
    tmux send-keys -t code:podman 'cd $SOURCE_DIR ; podman ps -a' Enter
fi

tmux attach-session -t main
