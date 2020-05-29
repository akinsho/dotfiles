#!/usr/bin/env zsh

#=======================================================================
# User configuration
#=======================================================================
export KEYTIMEOUT=1
bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^U' autosuggest-accept
#======================================================================
# NATIVE SETTINGS
#======================================================================
# persistent reshahing i.e puts new executables in the $path
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
# if no command is set typing in a line will cd by default
setopt AUTO_CD
setopt CORRECT
setopt RM_STAR_WAIT
# set some history options
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
# tab completing directory appends a slash
setopt autoparamslash
# command auto-correction
setopt correct

# Share your history across all your terminal windows
setopt share_history
# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
