OS=$(cat /etc/os-release | grep "^NAME=")

if [[ "$OS" == *"Vanilla OS"* ]]; then
	alias bat='batcat'
fi

alias bwu='eval "$($CONFIG_DIR/scripts/src/bw-unlock.php)"'
alias bye='tmux kill-server && exit'
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpull='git pull'
alias gs='git status'
alias kate='flatpak run org.kde.kate'
alias py='python3'
alias v='nvim'
