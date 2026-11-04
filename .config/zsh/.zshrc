# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)

## History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY        
setopt HIST_IGNORE_DUPS     
setopt HIST_IGNORE_SPACE    
setopt HIST_REDUCE_BLANKS

## Completions: rebuild the cache daily, not once per shell
setopt EXTENDED_GLOB  
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select                      # arrow through completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive
unsetopt EXTENDED_GLOB  

## Quality of life
setopt AUTO_CD 
setopt NO_BEEP
bindkey -e

## Tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)

## functions
fpath=("$ZDOTDIR/functions" $fpath)
autoload -Uz "$ZDOTDIR"/functions/*(N:t)

## Aliases
alias la='ls -lahG'
alias ll='ls -lhG'
alias lt='ls -lhtG'
alias lh="ls -A | egrep '^\.'"
alias kube='kubectl'
alias doco='docker compose'
alias dark="osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
alias glo="git log --oneline -n20"
alias gls='git log --oneline --color=always | fzf --ansi --no-sort --preview "git show --color=always {1}" --bind "enter:execute(echo {1} | pbcopy)+abort"'
alias gpf="git push --force-with-lease"
alias gvr='open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")'
alias gvp='open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")/pull-requests/'
alias gvb='open $(git config --get remote.origin.url | sed -E "s/git@(.*):(.*)\.git/https:\/\/\1\/\2/")/branch/$(git branch --show-current)'

## Plugins (install below; keep syntax-highlighting last)
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

export FZF_DEFAULT_OPTS="--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/projects/dotfiles/.config/zsh/.p10k.zsh.
[[ ! -f ~/projects/dotfiles/.config/zsh/.p10k.zsh ]] || source ~/projects/dotfiles/.config/zsh/.p10k.zsh
