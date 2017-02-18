# zmodload zsh/zprof
start_time="$(date +%s)"
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
# NB for future notice this tries to install in dotfiles unless explicitly
# specified here
export NVM_DIR="$HOME/.nvm"


# ZSH_TMUX_AUTOSTART="true"

export PATH="$PATH:`yarn global bin`"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.node/bin:$HOME/.rbenv/shims:$PATH
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# this line puts Python in the PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH

# export ZSH=$HOME/.oh-my-zsh

# Turn off default zsh vi mode indicator
# export RPS1="%{$reset_color%}"



#=======================================================================
#                 THEME
#=======================================================================

# PROMPT
# ➔ - default arrow
# ➼ - fun alternative
# ➪ - fun alternative2
# SPACESHIP_PROMPT_SYMBOL='➜ 🍕 👾 '
# SPACESHIP_PROMPT_ADD_NEWLINE=true

# TIME
# SPACESHIP_TIME_SHOW=true
# SPACESHIP_TIME_12HR=true

# VI_MODE
# SPACESHIP_VI_MODE_SHOW=true
# SPACESHIP_VI_MODE_INSERT="[Insert]"
# SPACESHIP_VI_MODE_NORMAL="[Normal]"
# GIT
# SPACESHIP_PREFIX_GIT='  on '
# SPACESHIP_PREFIX_NVM=' @ '
#=======================================================================



#=======================================================================
#                         ANTIGEN
#=======================================================================
ANTI_ZSH=/Users/A_nonymous/.dotfiles/zsh-antigen/antigen

# This is where antigen lives an where it is run super important
# Disable antigen's cache to always load latest changes from the plugin
export _ANTIGEN_CACHE_ENABLED=true
source $ANTI_ZSH/antigen.zsh
antigen init ~/.dotfiles/zsh-antigen/.antigenrc
#=======================================================================
# User configuration
#=======================================================================

add-zsh-hook precmd _z_precmd
function _z_precmd {
    _z --add "$PWD"
}
#=======================================================================
#               VI-MODE
#=======================================================================
# Default vi mode - not compatible with vi mode zsh plugin
# bindkey -v
# Binds vim mode terminal esc command to jk
# bindkey -M viins ‘jk’ vi-cmd-mode
# bindkey ‘^R’ history-incremental-search-backward


DEFAULT_USER=$USER

export MANPATH="/usr/local/man:$MANPATH"
export PATH=~/.rbenv:$PATH
# you may need to manually set your language environment
 export LANG=en_us.utf-8

# preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

# compilation flags
# export archflags="-arch x86_64"

# ssh
 export SSH_KEY_PATH="~/.ssh/rsa_id"


# if no command is set typing in a line will cd by default
setopt AUTO_CD
setopt CORRECT
setopt RM_STAR_WAIT


if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# default code for base16 shell
# base16_shell=$home/.config/base16-shell/
# [ -n "$ps1" ] && [ -s $base16_shell/profile_helper.sh ] && eval "$($base16_shell/profile_helper.sh)"
#create powerline env variable
# powerline-path='./library/python/2.7/lib/python/site-packages'

# persistent reshahing i.e puts new executables in the $path
zstyle ':completion:*' rehash true


# source all zsh and sh files inside dotfile/runcom
export dotfiles=$HOME/.dotfiles
export runcom=$DOTFILES/runcom/
source $dotfiles/runcom/functions.sh
source $dotfiles/runcom/zsh/alias.zsh
# for config ($RUNCOM/**/*) source $config - too dangerous
for fzfscript ($dotfiles/runcom/fzf/*.sh) source $fzfscript
for script ($dotfiles/runcom/zsh/*) source $script



# Setup global bookmarks cdg function
# ====================================
# Need to find a way to export this to my cdg function
unalias cdg 2> /dev/null
cdg() {
   local dest_dir=$(cdscuts_glob_echo | fzf )
   if [[ $dest_dir != '' ]]; then
      cd "$dest_dir"
   fi
}
# export -f cdg > /dev/null


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

bindkey '^ ' autosuggest-accept
# Automatically list directory contents on `cd`. slow things down
# unnecessarily
# auto-ls () { ls -m; }
# chpwd_functions=( auto-ls $chpwd_functions )


# Fzf ruby fuzzy finder very fast and adaptable
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

end_time="$(date +%s)"
# Compares start time defined above with end time above and prints the
# difference
echo load time: $((end_time - start_time)) seconds
# zprof
