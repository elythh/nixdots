##
## Keybindings
##

bindkey -s '^o' '_smooth_fzf^M'

# prepend sudo on the current commmand
bindkey -M emacs '' _sudo_command_line
bindkey -M viins '' _sudo_command_line
bindkey -M vicmd '' _sudo_command_line

# Manipulate command
bindkey "^H" backward-word
bindkey '^J' beginning-of-line
bindkey '^K' end-of-line
bindkey "^L" forward-word

bindkey "^U" backward-kill-line
bindkey "^D" kill-line

bindkey "^W" kill-word
# bindkey "^W" backward-kill-word
