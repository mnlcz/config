# PATH
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Default tools
EDITOR=vise; export EDITOR
PAGER=less; export PAGER

# Interactive shell config
ENV="$HOME/.shrc"; export ENV

# plan9port (commented until installed)
# export PLAN9=/home/mnlcz/Projects/plan9port
# export PATH=$PATH:$PLAN9/bin

# FreeBSD: handle /home symlink
if [ "$PWD" != "$HOME" ] && [ "$PWD" -ef "$HOME" ]; then cd; fi

# FreeBSD: fix terminal size on serial lines
if [ -x /usr/bin/resizewin ]; then /usr/bin/resizewin -z; fi

# Source environment modules
for rc in "$HOME/.shrc.d/0dirs.sh" "$HOME/.shrc.d/dev.sh"; do
    [ -f "$rc" ] && . "$rc"
done

# Display a random cookie on each login.
if [ -x /usr/bin/fortune ] ; then /usr/bin/fortune freebsd-tips ; fi
