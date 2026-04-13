#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing brew packages..."

# shell
brew install fish

# command-line tools
brew install fzf
brew install gh
brew install jq
brew install ripgrep
brew install trash
brew install tree
brew install entr
brew install zoxide
brew install fd
brew install bat
brew install felixkratz/formulae/borders

# terminal apps
brew install neovim
brew install tmux
brew install pgcli
brew install yazi
brew install btop
brew install serie
brew install anomalyco/tap/opencode

### Notes
# `serie`: git-commit graph. could be useful
# `posting`: good candidate for http client adoption
# `resterm`: for inspiration/reference since it uses a text-based request builder
# `harlequin`: decent sql-client, not sure how to navigate it but worth trying
# `phantom`: support git-worktres and tmux but windows/panes-based, not sessions

# dev
brew install stylua
brew install tree-sitter-cli
brew install erlang
brew install elixir
brew install oven-sh/bun/bun

# package managers
brew install asdf
brew install fisher

# containers
brew install docker
brew install colima
brew install kubectl
brew install derailed/k9s/k9s

# fonts
brew install --cask font-jetbrains-mono

# apps
brew install --cask wezterm
brew install --cask spotify
brew install --cask raycast
brew install --cask appcleaner
brew install --cask google-chrome
brew install --cask homerow
brew install --cask bruno
brew install --cask nikitabobko/tap/aerospace
