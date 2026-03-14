OS=$(cat /etc/os-release | grep "^NAME=")

if [[ "$OS" == *"Vanilla OS"* ]]; then
	alias bat='batcat'
fi

alias bye='tmux kill-server && exit'
alias v='nvim'
alias bwu='eval "$($CONFIG_DIR/scripts/bw-unlock.php)"'
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gpull='git pull'
alias py='python3'
