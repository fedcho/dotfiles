# Agent Guidelines

These are my personal dotfiles. The main things this project contains are:

- .config/nvim: the configuration for NVIM 0.11.6, written in lua. Based on kickstart.nvim but changed by me to make it modular.
- .config/fish: my shell configuration.
- .config/aerospace: my tiling window manager for macOS.
- .local/bin: some bash scripts made by me.
- .tmux.conf: my tmux configuration.
- .wezterm.lua: my terminal configuration.
- .gitconfig and other various configuration for my developer tools.

Many of these files are symlinked to my current system. For example, my .config/nvim setup is the real configuration files running nvim on my system.

There is also a set of bash scripts that automate the installation process on a new mac.

- install.sh: this is the entry point. It installs homebrew and clone the repo. README.md contains the instructions on how to use it.
- dotfiles.sh: is a cli with the main commands to install and apply the dotfiles.

I use several packages managers including homebrew, asdf, uv, and bun.

- crkbd-v4: contains the keyboard layout for my corne v4.1 mechanical keyboard.
