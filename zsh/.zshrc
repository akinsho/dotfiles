#!/bin/zsh
#-------------------------------------------------------------------------------
#               STARTUP TIMES
#-------------------------------------------------------------------------------
# zmodload zsh/zprof
# start_time="$(date +%s)"

#-------------------------------------------------------------------------------
#               Completion
#-------------------------------------------------------------------------------
# Init completions
autoload -Uz compinit
compinit

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' rehash true
#-------------------------------------------------------------------------------
#               Mappings
#-------------------------------------------------------------------------------
export KEYTIMEOUT=1
bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^U' autosuggest-accept
#-------------------------------------------------------------------------------
#               Options
#-------------------------------------------------------------------------------
setopt AUTO_CD
setopt RM_STAR_WAIT
# command auto-correction
setopt CORRECT
# set some history options
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt AUTOPARAMSLASH # tab completing directory appends a slash

# Share your history across all your terminal windows
setopt share_history
# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
#-------------------------------------------------------------------------------
#               Vi-mode
#-------------------------------------------------------------------------------
bindkey -v

#-------------------------------------------------------------------------------
#               Prompt
#-------------------------------------------------------------------------------
# icon options = 
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green} ●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red} ●%f" # default 'U'
zstyle ':vcs_info:git:*' formats "(%F{blue}%b%c%u%f)"

# Right prompt
RPROMPT='%F{240}%*%f'
# Left prompt
PROMPT='%(?.%F{green}.%F{red}?%?)%f %B%F{240}%1~%f%b${vcs_info_msg_0_} '
#-------------------------------------------------------------------------------
#           Plugins
#-------------------------------------------------------------------------------
# EMOJI-CLI
if [ -f $ZSH_CUSTOM/plugins/emoji-cli/emoji-cli.zsh ]; then
  source $ZSH_CUSTOM/plugins/emoji-cli/emoji-cli.zsh
fi

# Enhancd can't be setup as a submodule because the init.sh script
# deletes the source files on load...
if [ -f ~/enhancd/init.sh ]; then
  source ~/enhancd/init.sh
else
  git clone https://github.com/b4b4r07/enhancd ~/enhancd
  source ~/enhancd/init.sh
fi

PLUGIN_DIR=$DOTFILES/zsh/plugins

source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh
source $PLUGIN_DIR/alias-tips/alias-tips.plugin.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#-------------------------------------------------------------------------------
#   LOCAL SCRIPTS
#-------------------------------------------------------------------------------
# source all zsh and sh files
for script in $DOTFILES/zsh/scripts/*; do
  source $script
done

# reference - https://unix.stackexchange.com/questions/252166/how-to-configure-zshrc-for-specfic-os
if [[ `uname` == 'Linux' ]]; then
  source "$DOTFILES/linux/functions.sh"
fi

fpath+=${ZDOTDIR:-~}/.zsh_functions

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Aliases 'hub' to git to allow for greater git powah!!
eval "$(hub alias -s)"
eval $(thefuck --alias)

# STARTUP TIMES (CONTD)================================================
# end_time="$(date +%s)"
# Compares start time defined above with end time above and prints the
# difference
# echo load time: $((end_time - start_time)) seconds
# zprof
