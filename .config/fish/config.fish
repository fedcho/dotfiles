# Abbreviations
abbr -a lh "ls -A | egrep '^\.'"
abbr -a kube 'kubectl'
abbr -a doco 'docker compose'
abbr -a chop 'tmux-chop'
abbr -a dark "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
abbr -a glo "git log --oneline -n20"
abbr -a gpf "git push --force-with-lease"
abbr -a gvr 'open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")'
abbr -a gvp 'open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")/pull-requests/'
abbr -a gvb 'open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")/branch/$(git branch --show-current)'

# Environment
set -gx EDITOR nvim
set -gx K9S_CONFIG_DIR "$HOME/.config/k9s"

# Bun Setup
set -x BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

# Options
set fish_cursor_insert block 

fzf --fish | source
zoxide init fish | source
fnm env --use-on-cd --shell fish | source
