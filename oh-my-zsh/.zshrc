# export TERM="screen-256color"
export PATH="$PATH:`yarn global bin`"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.node/bin:$HOME/.rbenv/shims:$PATH
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# this line puts Python in the Path var
export PATH=$HOME/Library/Python/2.7/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH=/Users/A_nonymous/.oh-my-zsh

# Disable the default oh my zsh vi indicator
# export RPS1="%{$reset_color%}"


#=======================================================================

#                 THEME
#=======================================================================
ZSH_THEME="spaceship"
# PROMPT
# ➔ - default arrow
# ➼ - fun alternative
# ➪ - fun alternative2
SPACESHIP_PROMPT_SYMBOL='➜ 🍕 👾 '
SPACESHIP_PROMPT_ADD_NEWLINE=true

# TIME
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_12HR=true

# VI_MODE
SPACESHIP_VI_MODE_SHOW=true
SPACESHIP_VI_MODE_INSERT="[Insert]"
SPACESHIP_VI_MODE_NORMAL="[Normal]"
# GIT
SPACESHIP_PREFIX_GIT='  on '


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
DEFAULT_USER=$USER


#Cmd spetrum_ls shows all available terminal colors!!

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.


export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
# NB for future notice this tries to install in dotfiles unless explicitly
# specified here
export NVM_DIR="$HOME/.nvm"
plugins=(zsh-nvm vi-mode git npm brew tmux vundle git-auto-status web-search  common-aliases command-not-found)


ZSH_TMUX_AUTOSTART="true"

source $ZSH/oh-my-zsh.sh

#=======================================================================
# User configuration
#=======================================================================

#=======================================================================
#               VI-MODE
#=======================================================================
# Default vi mode - not compatible with vi mode zsh plugin
# bindkey -v
# Binds vim mode terminal esc command to jk
# bindkey -M viins ‘jk’ vi-cmd-mode
# bindkey ‘^R’ history-incremental-search-backward








export MANPATH="/usr/local/man:$MANPATH"

# you may need to manually set your language environment
 export lang=en_us.utf-8

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

# set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the zsh_custom folder.
# for a full list of active aliases, run `alias`.
#moved to .oh-my-zsh/lib/alias.zsh



# if no command is set typing in a line will cd by default
setopt AUTO_CD
setopt CORRECT
setopt RM_STAR_WAIT


if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# base16_shell="$home/.config/base16-shell/base16-ocean.dark.sh"
# [[ -s $base16_shell ]] && source $base16_shell
#
# default code for base16 shell
# base16_shell=$home/.config/base16-shell/
# [ -n "$ps1" ] && [ -s $base16_shell/profile_helper.sh ] && eval "$($base16_shell/profile_helper.sh)"
#create powerline env variable
# powerline-path='./library/python/2.7/lib/python/site-packages'

# persistent reshahing i.e puts new executables in the $path
zstyle ':completion:*' rehash true


# source all zsh and sh files inside dotfile/runcom
export DOTFILES=$HOME/.dotfiles
export runcom=$DOTFILES/runcom/
for config ($RUNCOM/**/*) source $config
# for fzfscript ($dotfiles/runcom/fzf/*.sh) source $fzfscript




# saves time cd’ing through dir tree’s you can do z end dir [tab]
# brew install z - the command below since i forgot activates z plugin
. `brew --prefix`/etc/profile.d/z.sh


export path=~/.rbenv:$path



test -e "${home}/.iterm2_shell_integration.zsh" && source "${home}/.iterm2_shell_integration.zsh"
# activates the 'fasd' plugin a more versatile file system traversal plugin
# source $zsh/plugins/fasd/fasd.plugin.zsh
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
