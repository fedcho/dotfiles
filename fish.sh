#!/usr/bin/env bash
set -eou pipefail

if command -v fish >/dev/null 2>&1; then
	echo "Configuring fish shell..."
	echo $(which fish) | sudo tee -a /etc/shells
	chsh -s $(which fish)

	fish -c "
		set -Ux HOMEBREW_NO_ENV_HINTS 1
		eval "$(/opt/homebrew/bin/brew shellenv fish)"
		fisher install pure-fish/pure
		"
else
	echo "fish shell not found."
fi

