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

# config session
if ! tmux has-session -t 'config' 2>/dev/null; then
    tmux new-session -d -s 'config' -n 'nvim'
    tmux send-keys -t config:nvim 'cd $CONFIG_DIR && nvim .' Enter
    # 2nd window
    tmux new-window -t config -n 'bash'
    tmux send-keys -t config:bash 'cd $CONFIG_DIR && git status' Enter
fi

tmux attach-session -t main
