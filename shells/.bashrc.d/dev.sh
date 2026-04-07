# tmux
"$CONFIG_DIR/scripts/init-tmux.sh"

# Git shortcuts
# D
export PATH="$PATH:/usr/local/src/dmd2/linux/bin64"
export PATH="$PATH:/usr/local/src/DCD/bin"

# Go
export GOPATH="$SOURCE_DIR/go"
export PATH="$PATH:$GOPATH/bin"

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python

# Rust
. "$HOME/.cargo/env"

# PHP
export PATH="$PATH:$HOME/.composer/vendor/bin"

# Development environment info
devinfo() {
    echo "=== Development Environment ==="
    echo "Bash: $(bash --version 2>/dev/null | head -n 1  || echo 'not installed')"
    echo "C: $(cc --version 2>/dev/null | head -n 1  || echo 'not installed')"
    echo "C3: $(c3c --version 2>/dev/null | head -n 1  || echo 'not installed')"
    echo "Git: $(git --version)"
    echo "Go: $(go version 2>/dev/null || echo 'not installed')"
    echo "JDK: $(java --version 2>/dev/null | head -n 1  || echo 'not installed')"
    echo "JRE: $(java --version 2>/dev/null | head -n 2 | tail -n 1  || echo 'not installed')"
    echo "Node: $(node --version 2>/dev/null || echo 'not installed')"
    echo "npm: $(npm --version 2>/dev/null || echo 'not installed')"
    echo "Podman: $(podman --version 2>/dev/null || echo 'not installed')"
    echo "PHP: $(php --version 2>/dev/null | head -n 1 || echo 'not installed')"
    echo "Python: $(python3 --version 2>/dev/null || echo 'not installed')"
    echo "Rust: $(rustc --version 2>/dev/null || echo 'not installed')"
}

# Quick project setup
mkproject() {
    local name=$1
    if [ -z "$name" ]; then
        echo "Usage: mkproject <project-name>"
        return 1
    fi

    mkdir -p "$SOURCE_DIR/$name"
    cd "$SOURCE_DIR/$name"
    git init
    echo "# $name" > README.md
    echo "Created project: $name"
}
