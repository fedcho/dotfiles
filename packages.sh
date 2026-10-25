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
brew install opencode
brew install hunk

# dev
brew install stylua
brew install tree-sitter-cli

# package managers
brew install fnm
brew install fisher

# containers
brew install docker
brew install colima
brew install kubectl
brew install derailed/k9s/k9s

# fonts
brew install --cask font-symbols-only-nerd-font	

# apps
brew install --cask wezterm
brew install --cask spotify
brew install --cask raycast
brew install --cask appcleaner
brew install --cask google-chrome
brew install --cask homerow
brew install --cask nikitabobko/tap/aerospace
