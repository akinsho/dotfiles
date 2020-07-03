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
