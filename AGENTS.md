# Agent Guidelines for dotfiles Repository

## Overview

This is a dotfiles repository containing shell scripts, configuration files, and system setup automation for macOS. The codebase consists primarily of Bash scripts, configuration files for terminal apps (tmux, wezterm, neovim), and system preferences.

## Build, Lint, and Test Commands

Since this is a dotfiles repository, there is no traditional build process. However, scripts can be validated using the following methods:

### Shell Script Linting

```bash
# Lint all shell scripts with shellcheck
shellcheck dotfiles.sh install.sh github.sh docker-compose.sh macos.sh

# Lint with specific severity level
shellcheck -s bash -e SC1091 dotfiles.sh

# Check for common issues in all .sh files
find . -name "*.sh" -exec shellcheck {} \;
```

### Syntax Validation

```bash
# Check bash syntax without execution
bash -n dotfiles.sh
bash -n install.sh

# Verify execute permissions
ls -la *.sh
```

### Verbosity

Some scripts support verbose modes:

```bash
./dotfiles.sh -v apply  # verbose output
```

## Code Style Guidelines

### Shell Scripts (Bash)

- **Shebang**: Use `#!/usr/bin/env bash` for all shell scripts
- **Strict Mode**: Enable at the top of scripts: `set -euo pipefail`
- **Quotes**: Always double-quote variable expansions: `"$HOME/.ssh"` not `$HOME/.ssh`
- **Arrays**: Use Bash arrays for lists (see DOTFILES array in dotfiles.sh:5-20)
- **Conditionals**: Use `[[ ]]` for conditionals with proper quoting
- **Command Checks**: Use `command -v foo >/dev/null 2>&1` for existence checks
- **Error Handling**: Exit early on errors with `set -e` and use descriptive error messages
- **Functions**: Use lowercase with underscores: `cmd_apply()`, `show_help()`

### Naming Conventions

- **Variables**: Lowercase with underscores: `verbose`, `ssh_dir`, `version`
- **Constants/Globals**: Uppercase: `DOTFILES`, `SSH_IDENTITY`
- **Functions**: `cmd_*` pattern for subcommand functions, lowercase with underscores
- **Files**: Descriptive lowercase with hyphens for multi-word names

### Error Handling

```bash
# Proper error handling pattern
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    # ... installation code
fi

# Check file existence before operations
if [[ ! -f "$SSH_IDENTITY" ]]; then
    echo "Generating ssh key..."
fi

# Check directory conditions
if [[ ! -d "$HOME/projects/dotfiles" ]]; then
    mkdir -p $HOME/projects
fi
```

### Imports and Dependencies

- Use `command -v` to check for tool availability before use
- Install Homebrew early if missing (see install.sh:4-11)
- Source brew shellenv: `eval "$(/opt/homebrew/bin/brew shellenv)"`
- Use absolute paths when available, e.g., `/usr/bin/env bash`

### Formatting

- Indent with tabs (2 spaces equivalent)
- Align array elements with tabs for readability
- Use heredocs for multi-line output and configuration
- Keep lines under 100 characters when possible
- Group related code with blank lines

### Git Configuration

- Use the provided `.gitconfig` aliases: `git co`, `git st`, `git br`, `git cm`
- Rebase strategy for pulls: `pull.rebase = true`
- Commit email: configured for `fer.caldera@gmail.com`

### Configuration Files

- **tmux**: Use standard configuration format, place plugins at bottom
- **git**: Use INI format with section headers
- **Brewfile**: Maintain tap declarations at top, grouped by category
- **Editor**: Set to neovim (`nvim`)

### Common Patterns

**Architecture detection** (docker-compose.sh:4-11):

```bash
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) ARCH_TAG="x86_64" ;;
  arm64)  ARCH_TAG="aarch64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac
```

**Subcommand dispatch** (dotfiles.sh:120-137):

```bash
case "${1:-help}" in
  install) cmd_install "$@" ;;
  apply) cmd_apply "$@" ;;
  help | -h | --help) show_help ;;
  *) echo "Unknown subcommand: $1"; show_help ;;
esac
```

**SSH setup with agent** (github.sh:19-25):

```bash
if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
    eval "$(ssh-agent -c)"
fi
ssh-add "$SSH_IDENTITY"
```

### Working with this Repository

- All scripts are in the root directory
- Symlink dotfiles via `./dotfiles.sh apply`
- Install all tools via `./dotfiles.sh install`
- Full setup via `./install.sh` (requires Homebrew)
- Configuration is organized under `.config/` for app-specific settings
- Run shellcheck before committing shell script changes
