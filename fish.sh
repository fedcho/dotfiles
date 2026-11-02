#!/usr/bin/env bash
set -euo pipefail

if ! command -v fish >/dev/null 2>&1; then
	echo "fish shell not found."
	exit 1
fi

FISH_PATH=$(which fish)

# set as default shell only if it is not the default shell already
if ! grep -qxF "$FISH_PATH" /etc/shells; then
	echo "Adding $FISH_PATH to /etc/shells..."
	echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$SHELL" != "$FISH_PATH" ]]; then
	echo "Setting fish as default shell..."
	chsh -s "$FISH_PATH"
else
	echo "Fish is already the default shell."
fi

# configure prompt
if fish -c 'fisher list' | grep -qxF 'pure-fish/pure'; then
	echo "Pure prompt already installed."
else
	echo "Installing Pure prompt via fisher..."
	fish -c 'fisher install pure-fish/pure'
fi
