export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export K9S_CONFIG_DIR="$XDG_CONFIG_HOME/k9s"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

export FZF_DEFAULT_OPTS="--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
