# tmux: run if not in acme and not already in tmux
#if [ -z "$winid" ] && [ -z "$TMUX" ]; then
#    "$CSCRIPTS/init-tmux.sh"
#fi

devinfo() {
    echo "=== Development Environment ==="
    for tool in cc git go java node npm php python3 rustc podman; do
        version=$(command -v "$tool" > /dev/null 2>&1 && "$tool" --version 2>/dev/null | head -n 1 || echo "not installed")
        echo "$tool: $version"
    done
}

mkproject() {
    name=$1
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
