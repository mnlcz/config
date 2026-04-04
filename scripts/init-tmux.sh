#!/bin/bash
#!/bin/bash

OS=$(cat /etc/os-release | grep "^NAME=")

if [ -n "$TMUX" ]; then
    exit 0
fi

# Create main session if it doesn't exist
if ! tmux has-session -t 'main' 2>/dev/null; then
    tmux new-session -d -s 'main'
    tmux send-keys -t main 'cd ~ ; clear ; fastfetch -c $CONFIG_DIR/tools/fastfetch/medium.jsonc ; $CONFIG_DIR/scripts/updates.php' Enter
fi

# Create code session based on OS
if ! tmux has-session -t 'code' 2>/dev/null; then
    if [[ "$OS" == *"Vanilla OS"* ]]; then
        tmux new-session -d -s 'code' -n "shell"
        tmux send-keys -t code:shell 'cd $SOURCE_DIR ; clear ; ls -lah' Enter
        tmux new-window -t code -n 'runner'
        tmux send-keys -t code:runner 'cd $SOURCE_DIR ; clear ; ls -lah' Enter
    else
        tmux new-session -d -s 'code' -n "shell"
        tmux send-keys -t code:shell 'cd $SOURCE_DIR ; clear ; x ls' Enter
        tmux new-window -t code -n 'editor'
        tmux send-keys -t code:editor 'cd $SOURCE_DIR ; clear ; nvim -V1 -v' Enter
        tmux new-window -t code -n 'runner'
        tmux send-keys -t code:runner 'cd $SOURCE_DIR ; clear ; x ls' Enter
        tmux new-window -t code -n 'podman'
        tmux send-keys -t code:podman 'cd $SOURCE_DIR ; clear ; podman ps -a' Enter
    fi
fi

tmux attach-session -t main
