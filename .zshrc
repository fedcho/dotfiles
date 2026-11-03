fpath+=("$(brew --prefix)/share/zsh/site-functions")

## History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY        
setopt HIST_IGNORE_DUPS     
setopt HIST_IGNORE_SPACE    
setopt HIST_REDUCE_BLANKS

## Completion: rebuild the cache daily, not once per shell
setopt EXTENDED_GLOB  
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
unsetopt EXTENDED_GLOB  

## Quality of life
setopt AUTO_CD 
setopt NO_BEEP
bindkey -e

## Tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)

## Prompt
autoload -U promptinit; promptinit
prompt pure

## Plugins (install below; keep syntax-highlighting last)
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

## Environment
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"
