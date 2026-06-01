# tmux: run if not in acme and not already in tmux
if [ -z "$winid" ] && [ -z "$TMUX" ]; then
    "$CSCRIPTS/init-tmux.sh"
fi

export PLAN9=/usr/local/plan9
export PATH=$PATH:$PLAN9/bin
