#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
	echo "Installing Homebrew..."
	sudo -v
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	brew update
fi

if [ ! -d "$HOME/projects/dotfiles" ]; then
	mkdir -p $HOME/projects
	git clone https://github.com/fedcho/dotfiles $HOME/projects/dotfiles
fi

cd $HOME/projects/dotfiles
./dotfiles.sh -v install
./dotfiles.sh -v apply

echo "Installing mise tools..."
mise install -y
