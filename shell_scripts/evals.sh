#!/bin/zsh
# Aliases 'hub' to git to allow for greater git powah!!
eval "$(hub alias -s)"

# Plugin that autocorrects when you type fuck or whatever alias you intended
eval "$(thefuck --alias)"
