#-------------------------------------------------------------------------------
# References:
#-------------------------------------------------------------------------------
# Color table - https://jonasjacek.github.io/colors/
# Wincent's dotfiles - https://github.com/wincent/wincent/blob/d6c52ed552/aspects/dotfiles/files/.zshrc
# https://github.com/vincentbernat/zshrc/blob/d66fd6b6ea5b3c899efb7f36141e3c8eb7ce348b/rc/vcs.zsh
# sourcing autoloaded functions:
# https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh
# Git prompt script: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

zmodload zsh/datetime

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'


PLUGIN_DIR=$DOTFILES/zsh/plugins

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Init completions
autoload -Uz compinit
compinit

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }
#-------------------------------------------------------------------------------
#           Plugins
#-------------------------------------------------------------------------------
# These should be source *BEFORE* setting up hooks
source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh
source $PLUGIN_DIR/alias-tips/alias-tips.plugin.zsh
source $PLUGIN_DIR/zsh-auto-notify/auto-notify.plugin.zsh
source $PLUGIN_DIR/last-working-dir/last-working-dir.zsh
autoload zmv # builtin zsh rename command
#-------------------------------------------------------------------------------
#               Completion
#-------------------------------------------------------------------------------
# Completion for kitty
if [[ "$TERM" == "xterm-kitty" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select
zmodload zsh/complist

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' rehash true

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
# Style the group names
zstyle ':completion:*' format %F{yellow}%B%U%{$__DOTS[ITALIC_ON]%}%d%{$__DOTS[ITALIC_OFF]%}%b%u%f

# Added by running `compinstall`
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
# End of lines added by compinstall

# Make completion:
# (stolen from Wincent)
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#-------------------------------------------------------------------------------
#               Options
#-------------------------------------------------------------------------------
setopt AUTO_CD
setopt RM_STAR_WAIT
setopt CORRECT                  # command auto-correction
setopt COMPLETE_ALIASES
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt AUTOPARAMSLASH            # tab completing directory appends a slash
setopt SHARE_HISTORY             # Share your history across all your terminal windows
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
#-------------------------------------------------------------------------------
#               Vi-mode
#-------------------------------------------------------------------------------
bindkey -v # enables vi mode, using -e = emacs

# Correction prompt
export SPROMPT="correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "
#-------------------------------------------------------------------------------
#           Hooks
#-------------------------------------------------------------------------------
autoload -Uz add-zsh-hook

function __auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -a
  fi
}


add-zsh-hook chpwd () {
  chpwd_last_working_dir
}

if exists starship; then
  eval "$(starship init zsh)"
fi
#-------------------------------------------------------------------------------
#   LOCAL SCRIPTS
#-------------------------------------------------------------------------------
# source all zsh and sh files
for script in $DOTFILES/zsh/scripts/*; do
  source $script
done

# reference - https://unix.stackexchange.com/questions/252166/how-to-configure-zshrc-for-specfic-os
case `uname` in
  Darwin)
    source "$DOTFILES/macos/init.sh"
    ;;
  Linux)
    source "$DOTFILES/linux/functions.sh"
    ;;
esac

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
ZSH_AUTOSUGGEST_USE_ASYNC=1

# TODO: also need to check for the existence of ~/.fzf/
if [ ! -f ~/.fzf.zsh ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if exists hub; then
  eval "$(hub alias -s)" # Aliases 'hub' to git
fi

if [[ ! "$(exists nvr)" && "$(exists pip3)" ]]; then
  pip3 install neovim-remote
fi

if exists thefuck; then
  eval $(thefuck --alias)
fi

if exists zoxide; then
  eval "$(zoxide init zsh)"
fi

#-------------------------------------------------------------------------------
#               PYENV
#-------------------------------------------------------------------------------
# NOTE: this is loaded after home brew as it was installed via homebrew and will
# otherwise not exist if homebrew does not
if exists pyenv; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

#-------------------------------------------------------------------------------
#               Mappings
#-------------------------------------------------------------------------------
export KEYTIMEOUT=1
bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^U' autosuggest-accept
