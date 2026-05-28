OS=$(uname)
if [ "$OS" = "FreeBSD" ]; then
    alias v='vise'
fi
alias bye='tmux kill-server && exit'
alias ff='fastfetch -c $CONF/tools/fastfetch/small.jsonc'
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
alias ll='ls -laFoh'
alias py='python3.14'
