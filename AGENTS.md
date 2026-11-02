# Agent Guidelines

Personal dotfiles, symlinked into my home directory by `./dotfiles.sh apply`.

## Invariants

- The symlinked files ARE my live system (nvim, fish, aerospace, tmux, wezterm...).
  Edits here take effect on the running setup.
- The authoritative file lists live in the scripts; don't maintain copies here:
  - files to link: `dotfiles.sh` (`DOTFILES` array)
  - packages to install: `packages.sh`
  - tool versions: `.config/mise/config.toml`

## Setup flow

`install.sh` bootstraps a new machine: Homebrew → `dotfiles.sh install`
(brew packages, fish, misc scripts) → `dotfiles.sh apply` (symlinks) →
`mise install` (runtimes). Don't run these blindly on the current machine.

## Verifying changes

- fish configs: `fish -n <file>`
- bash scripts: `bash -n <file>`
