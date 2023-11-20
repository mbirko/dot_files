. /Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/powerline/bindings/zsh/powerline.zsh
# Source: https://unix.stackexchange.com/a/113768
# Check if tmux is aviailable, if shell is interactive, if terminal is not screen or tmux, and if tmux is not already running
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

function cduni {
	echo "navigated to Uni/$1"	
	cd ~/Dropbox\ \(Personal\)/Uni/$1
}
source ~/.my_commands

PATH=/opt/local/bin:$PATH
export PATH="$PATH:/Users/mathiasolsen/Library/Application Support/Coursier/bin"

[ -f "/Users/mathiasolsen/.ghcup/env" ] && source "/Users/mathiasolsen/.ghcup/env" # ghcup-env


# source: https://dev.to/iggredible/how-to-search-faster-in-vim-with-fzf-vim-36ko
# Conf for fzf
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# source: thecodinglab
# nix shell indicator
function in_nix_shell() {
    if [ ! -z ''${IN_NIX_SHELL+x} ];
      then echo ">>nix<<";
    fi
}
RPS1="%F{yellow}%b$(in_nix_shell)%f$RPS1"
