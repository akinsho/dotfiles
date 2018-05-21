#!/bin/zsh

#=======================================================================
#                 SPACESHIP THEME
#=======================================================================

# PROMPT
# ➔ - default arrow
# ➼ - fun alternative
# ➪ - fun alternative2
# SPACESHIP_PROMPT_SYMBOL='➜  '
SPACESHIP_CHAR_SYMBOL='🍕 '
export SPACESHIP_PROMPT_ADD_NEWLINE=true
export SPACESHIP_PROMPT_SEPARATE_LINE=true
# VI_MODE
export SPACESHIP_VI_MODE_SHOW=true
export SPACESHIP_VI_MODE_INSERT="[i]"
export SPACESHIP_VI_MODE_NORMAL="[n]"
# GIT
export SPACESHIP_GIT_PREFIX='  on '
export SPACESHIP_GIT_STATUS_STASHED=' 💰 '
export SPACESHIP_GIT_STATUS_UNTRACKED=' 😰 '
export SPACESHIP_NODE_PREFIX=' @ '
export SPACESHIP_RUBY_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false
# PYENV
export SPACESHIP_PYENV_SHOW=   false
export SPACESHIP_PYENV_SYMBOL='🐍'
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export GIT_UNCOMMITTED="+"
export GIT_UNSTAGED="!"
export GIT_UNTRACKED="?"
export GIT_STASHED="$"
export GIT_UNPULLED="⇣"
export GIT_UNPUSHED="⇡"

