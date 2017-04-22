#=======================================================================
#               STARTUP TIMES
#=======================================================================
# zmodload zsh/zprof
# start_time="$(date +%s)"
#=======================================================================
#       ENV VARIABLES
#=======================================================================
export NVM_LAZY_LOAD=true
# export NVM_AUTO_USE=true
# NB for future notice this tries to install in dotfiles unless explicitly
# specified here
export NVM_DIR="$HOME/.nvm"


# ZSH_TMUX_AUTOSTART="true"


export DOTFILES=$HOME/Dotfiles
export RUNCOM=$DOTFILES/runcom/

export PATH="$PATH:`yarn global bin`"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.node/bin:$HOME/.rbenv/shims:$PATH
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# this line puts Python in the PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH
# GO ============================================================
export GOROOT=/usr/local/opt/go/libexec
# export GOPATH=$HOME/.go
export GOPATH=$HOME/Desktop/Coding/Go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$(go env GOPATH)/bin

# RUBY ==========================================================
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/A_nonymous/.oh-my-zsh

ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=5

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
export ZSH_CUSTOM=$HOME/Dotfiles/oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# PLUGINS =======================================================================
plugins=(alias-tips git gitfast zsh-completions command-not-found colored-man-pages z common-aliases brew heroku )

# web-search - great plugin, google from the command line although I never use
# it soo...

source $ZSH/oh-my-zsh.sh

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

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Change the path where project plugin creates projects
export PROJECTS_HOME=~/Desktop/Coding
# Aliases 'hub' to git to allow for greater git powah!!
eval "$(hub alias -s)"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
#=======================================================================
#                 SPACESHIP THEME
#=======================================================================

# PROMPT
# ➔ - default arrow
# ➼ - fun alternative
# ➪ - fun alternative2
SPACESHIP_PROMPT_SYMBOL='➜ 🍕 👾 '
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true
# TIME
# SPACESHIP_TIME_SHOW=true
# SPACESHIP_TIME_12HR=true

# VI_MODE
SPACESHIP_VI_MODE_SHOW=true
SPACESHIP_VI_MODE_INSERT="[Insert]"
SPACESHIP_VI_MODE_NORMAL="[Normal]"
# GIT
SPACESHIP_PREFIX_GIT='  on '
SPACESHIP_GIT_STASHED=' 💰 '
SPACESHIP_GIT_UNTRACKED=' 😰 '


SPACESHIP_PREFIX_NVM=' @ '
SPACESHIP_NVM_SHOW=true


SPACESHIP_RUBY_SHOW=false
# PYENV
SPACESHIP_PYENV_SHOW=   false
SPACESHIP_PYENV_SYMBOL='🐍'

#=======================================================================
# User configuration
#=======================================================================
# auto-ls () { ls -GC; }
# chpwd_functions=( auto-ls $chpwd_functions )

# add-zsh-hook precmd _z_precmd
# function _z_precmd {
#   _z --add "$PWD"
# }
export KEYTIMEOUT=1

bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^U' autosuggest-accept
# bindkey '^Z' 
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
setopt autoparamslash       # tab completing directory appends a slash
setopt correct              # command auto-correction

# Share your history across all your terminal windows
setopt share_history
# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history



# POWERLINE ==========================================================
if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
  source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi
# BASE16===============================================================
# default code for base16 shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

# EMOJI-CLI 
source $ZSH_CUSTOM/plugins/emoji-cli/emoji-cli.zsh


#ENHANCD ================================================================

source ~/enhancd/init.sh
#=======================================================================
#   LOCAL SCRIPTS
#=======================================================================
# source all zsh and sh files inside dotfile/runcom
source $DOTFILES/runcom/functions.sh
source $DOTFILES/runcom/zsh/alias.zsh
for fzfscript ($DOTFILES/runcom/fzf/*.sh) source $fzfscript
  for script ($DOTFILES/runcom/zsh/*) source $script

source $DOTFILES/local/.localrc
#=======================================================================
#       FUNCTIONS
#=======================================================================
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z



    # Plugin that autocorrects when you type fuck or whatever alias you intended
eval "$(thefuck --alias fuck)"

# iTERM Integration ==================================================
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# STARTUP TIMES (CONTD)================================================
end_time="$(date +%s)"
# Compares start time defined above with end time above and prints the
# difference
# echo load time: $((end_time - start_time)) seconds
# zprof

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#Syntax Highlighting for ZSH
#IMPORTANT NOTE TO SELF - These plugins if reloaded on sourcing zshrc will
#crash the shell
# if [ -z "$_zsh_custom_scripts_loaded" ]; then
#   _zsh_custom_scripts_loaded=1
#   plugins+=(zsh-autosuggestions zsh-syntax-highlighting)
# fi
if [[ $ZSH_EVAL_CONTEXT == 'file' ]]; then
  # printf "autosuggestions loaded"
  source ~/Dotfiles/oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ~/Dotfiles/oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi
