# Abbreviations
abbr -a lh "ls -A | egrep '^\.'"
abbr -a kube 'kubectl'
abbr -a doco 'docker compose'
abbr -a chop 'tmux-chop'
abbr -a osdm "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"

# Environment
set -gx EDITOR nvim
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH $BUN_INSTALL/bin $PATH

# Options
set fish_cursor_insert block 

# Plugins
if test -f  ~/.asdf/asdf.fish
  source ~/.asdf/asdf.fish
else if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
 source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

fzf --fish | source
zoxide init fish | source

