#!/usr/bin/env bash

verbose=false

DOTFILES=(
	".gitconfig"
	".rgignore"
	".tmux.conf"
	".wezterm.lua"
	".config/nvim"
	".config/aerospace"
	".config/fish/config.fish"
	".config/fish/functions/fish_user_key_bindings.fish"
	".config/wezterm"
	".config/opencode/opencode.json"
	".local/bin/tmux-chop"
	".local/bin/tmux-auto"
	".tmux/themes"
	".config/k9s/aliases.yaml"
	".config/k9s/config.yaml"
	".config/k9s/skins"
)

show_help() {
	cat <<EOF
Usage: $0 <subcommand> [args]

Subcommands:
  install    Install tools and apps
  apply      Symlink dotfiles
  help       Show this help

Global flags:
  -v         Verbose output

EOF

	exit 0
}

cmd_apply() {
	for dotfile in "${DOTFILES[@]}"; do
		src="${PWD}/${dotfile}"
		target="${HOME}/${dotfile}"

		if $verbose; then echo "Linking $src -> $target"; fi

		mkdir -p "$(dirname "$target")"
		[[ -L $target ]] && rm -rf "$target"
		ln -sf "$src" "$target"
	done
	echo "Dotfiles applied."
}

cmd_install() {
	./packages.sh
	./fish.sh
	./github.sh
	./docker.sh
	./macos.sh

	echo "Done!"
}

# parse global options
while getopts ":vh" opt; do
	case $opt in
	h) show_help ;;
	v) verbose=true ;;
	\?)
		echo "Invalid option: -$OPTARG"
		show_help
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

# Dispatch subcommand
case "${1:-help}" in
install)
	shift
	cmd_install "$@"
	;;
apply)
	shift
	cmd_apply "$@"
	;;
help | -h | --help)
	shift
	show_help
	;;
*)
	echo "Unknown subcommand: $1"
	show_help
	;;
esac
