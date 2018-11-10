#!/bin/zsh
# Aliases 'hub' to git to allow for greater git powah!!
eval "$(hub alias -s)"
##---------------------------------------------------------------------------/
## NPX - AUTO-FALL-BACK COMMAND
##---------------------------------------------------------------------------///
# source <(npx --shell-auto-fallback zsh)

#Pyenv
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# Plugin that autocorrects when you type fuck or whatever alias you intended
eval "$(thefuck --alias)"
# iTERM Integration ==================================================
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
