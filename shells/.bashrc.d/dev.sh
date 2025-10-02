export REPOS_DIR="$HOME/repos"
export CONFIG_DIR="$HOME/repos/config"

# tmux
"$CONFIG_DIR/scripts/init-tmux.sh"

# Git shortcuts
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

# Go
export GOPATH="$REPOS_DIR/source/go"
export PATH="$PATH:$GOPATH/bin"

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python
alias py='python3'

# Rust
. "$HOME/.cargo/env"

# Development environment info
devinfo() {
    echo "=== Development Environment ==="
    echo "Node: $(node --version 2>/dev/null || echo 'not installed')"
    echo "npm: $(npm --version 2>/dev/null || echo 'not installed')"
    echo "Python: $(python3 --version 2>/dev/null || echo 'not installed')"
    echo "Go: $(go version 2>/dev/null || echo 'not installed')"
    echo "Rust: $(rustc --version 2>/dev/null || echo 'not installed')"
    echo "Podman: $(podman --version 2>/dev/null || echo 'not installed')"
    echo "Git: $(git --version)"
}

# Quick project setup
mkproject() {
    local name=$1
    if [ -z "$name" ]; then
        echo "Usage: mkproject <project-name>"
        return 1
    fi
    
    mkdir -p "$REPOS_DIR/$name"
    cd "$REPOS_DIR/$name"
    git init
    echo "# $name" > README.md
    echo "Created project: $name"
}
