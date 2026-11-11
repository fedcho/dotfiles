function fish_user_key_bindings
    fish_vi_key_bindings 

    bind -M fish_vi_command \$ end-of-line
    bind -M insert \cp up-or-search
    bind -M insert \cn down-or-search
    bind -M insert \cf accept-autosuggestion

    # C-d must never exit the shell (the preset delete-or-exit would on an empty prompt)
    bind -M insert \cd delete-char
    bind -M default \cd delete-char
end
