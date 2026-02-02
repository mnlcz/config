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

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Open source graphics setup for Zed
export ZED_ALLOW_EMULATED_GPU=1
# export ZED_DEVICE_ID=0x2484 zed

# Setup manual installation of texlive
export MANPATH="/usr/local/texlive/2025/texmf-dist/doc/man"
export INFOPATH="/usr/local/texlive/2025/texmf-dist/doc/info"
export PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux"

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
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

PATH="/home/mnlcz/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/mnlcz/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mnlcz/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mnlcz/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mnlcz/perl5"; export PERL_MM_OPT;
