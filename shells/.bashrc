# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
set -o vi

alias v='nvim'
alias sv='sudo nvim'
alias ll='ls -la'

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="$ID"
else
    DISTRO_ID="unknown"
fi

if [ "$DISTRO_ID" = "gentoo" ]; then
    alias vdwm='sudo nvim /etc/portage/savedconfig/x11-wm/dwm-6.5.h'
    # Prevent npm from installing stuff to /usr for safe coliving with Portage
    export NPM_CONFIG_PREFIX=$HOME/.local/
    export PATH="/home/$USER/go/bin:/home/$USER/.local/bin:$NPM_CONFIG_PREFIX/bin:$PATH"
elif [ "$DISTRO_ID" = "debian" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Rust cargo
export PATH="$PATH:~/.cargo/bin"
