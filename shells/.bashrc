# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Setup nvim as man pages reader
export MANPAGER='nvim +Man!'

# bat theme
export BAT_THEME="GitHub"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --color light
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# X-CMD
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd. Check the generated .bash_profile
# Fix conflicts with system tools
unset -f c  # Restore RHEL command-line-assistant

# plan9port
PLAN9=/home/mnlcz/Source/repos/plan9port
PATH=$PATH:$PLAN9/bin

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


