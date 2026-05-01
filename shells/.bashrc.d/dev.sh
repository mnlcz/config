# tmux, run if not in acme
if [ -z "$winid" ]; then
    "$CSCRIPTS/init-tmux.sh"
fi

# D
export PATH="$PATH:/usr/local/src/dmd2/linux/bin64"
export PATH="$PATH:/usr/local/src/DCD/bin"

# Go
export GOPATH="$HOME/Projects/go"
export PATH="$PATH:$GOPATH/bin"

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# deno
. "/home/mnlcz/.deno/env"
# pnpm
export PNPM_HOME="/home/mnlcz/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# perl
PATH="/home/mnlcz/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/mnlcz/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mnlcz/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mnlcz/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mnlcz/perl5"; export PERL_MM_OPT;

# PHP
export PATH="$PATH:$HOME/.composer/vendor/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# TEX. Setup manual installation of texlive
export MANPATH="/usr/local/texlive/2025/texmf-dist/doc/man:${MANPATH:-}"
export INFOPATH="/usr/local/texlive/2025/texmf-dist/doc/info"
export PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux"

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

    mkdir -p "$HOME/Projects/$name"
    cd "$HOME/Projects/$name"
    git init
    echo "# $name" > README.md
    echo "Created project: $name"
}
