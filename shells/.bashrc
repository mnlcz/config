# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source environment
[ -f ~/.profile ] && . ~/.profile

# Custom prompt
PROMPT_COLOR="\[\e[38;2;0;0;168m\]"   # CGA blue (true color)
PROMPT_RESET="\[\e[0m\]"
PS1="${PROMPT_COLOR}\u@\h${PROMPT_RESET}:\[\e[1m\]\w${PROMPT_RESET}\$ "

# Aliases
[ -f ~/.bashrc.d/aliases.sh ] && . ~/.bashrc.d/aliases.sh

# Setup nvim as man pages reader
export MANPAGER='nvim +Man!'

# bat theme
export BAT_THEME="GitHub"

# ls color for symlinks
export LS_COLORS="${LS_COLORS/ln=01;36/ln=38;2;0;0;168}"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --color light
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# X-CMD
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X"
# Fix conflicts with system tools
unset -f c  # Restore RHEL command-line-assistant

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
