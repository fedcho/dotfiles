# Abbreviations
abbr -a lh "ls -A | egrep '^\.'"
abbr -a kube 'kubectl'
abbr -a doco 'docker compose'
abbr -a chop 'tmux-chop'
abbr -a dark "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
abbr -a glo "git log --oneline -n20"
abbr -a gpf "git push --force-with-lease"
abbr -a gvr 'open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")'

# Environment
set -gx EDITOR nvim
set -gx K9S_CONFIG_DIR "$HOME/.config/k9s"

# Bun Setup
set -x BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

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

