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
export RPS1="%{$reset_color%}"
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
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
# ZSH_THEME="powerlevel9k/powerlevel9k"
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_DELIMITER=".."
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_right"
# POWERLEVEL9K_DISABLE_RPROMPT=true
# POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="\n ↳ 🍕 👍🏾  "
# #"↳ ""↱"
# POWERLEVEL9K_MODE='awesome-fontconfig'
# #Use command spectrum_ls to see available colors and codes
# POWERLEVEL9K_TIME_BACKGROUND='111'
# POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='208'
# #'220'
# POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='black'
# POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='154'
# POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='black'
# POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='black'
# POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND='039'
# POWERLEVEL9K_BATTERY_LOW_THRESHOLD='20'
# POWERLEVEL9K_BATTERY_LOW_COLOR='black'
# POWERLEVEL9K_BATTERY_LOW_BACKGROUND='161'
# POWERLEVEL9K_OS_ICON_BACKGROUND='red'
# #009
# POWERLEVEL9K_DIR_HOME_FOREGROUND='236'
# POWERLEVEL9K_DIR_HOME_BACKGROUND='009'
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='236'
# #178
# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='009'
# #'075'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='236'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='009'
# POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='teal'
# POWERLEVEL9K_STATUS_OK_BACKGROUND='yellow'
# POWERLEVEL9K_OK_ICON='💯'
# POWERLEVEL9K_ERROR_ICON='💩'
# POWERLEVEL9K_STATUS_VERBOSE=false
# POWERLEVEL9K_BATTERY_ICON="🔌 "
#
# zsh_wifi_signal(){
#         local signal=$(nmcli device wifi | grep yes | awk '{print $8}')
#         local color='%F{yellow}'
#         [[ $signal -gt 75 ]] && color='%F{green}'
#         [[ $signal -lt 50 ]] && color='%F{red}'
#         echo -n "%{$color%}\uf230  $signal%{%f%}" # \uf230 is 
# }
# #custom_wifi_signal
# POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir_joined vcs battery )
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status nodeenv vi_mode time)
# # Output time, date, and a symbol from the "Awesome Powerline Font" set
# POWERLEVEL9K_CUSTOM_TIME_FORMAT="%D{\uf017 %H:%M:%S}"
# POWERLEVEL9K_TIME_FORMAT="%D{\uf017 %H:%M \uf073 %d.%m.%y}"
# POWERLEVEL9K_TIME_FORMAT="🕰   %D{%H:%M %d.%m.%y}"
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
plugins=(vi-mode git npm brew tmux vundle git-auto-status web-search  common-aliases command-not-found)


ZSH_TMUX_AUTOSTART="false"
#ZSH_TMUX_AUTOSTART="true"

source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
 export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#Moved to .oh-my-zsh/lib/alias.zsh



# If no command is set typing in a line will cd by default
setopt AUTO_CD
setopt CORRECT
setopt RM_STAR_WAIT


if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
#
# Default code for Base16 Shell
# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
#Create powerline env variable
# powerline-path='./Library/Python/2.7/lib/python/site-packages'

# Persistent reshahing i.e puts new executables in the $PATH
zstyle ':completion:*' rehash true


# source all zsh and sh files inside dotfile/runcom/zsh
export DOTFILES=$HOME/.dotfiles
export DOTZSH=$DOTFILES/runcom/zsh
for config ($DOTFILES/**/*.zsh) source $config
# for config ($DOTZSH/**/*.sh) source $config
source ~/.dotfiles/tmux/tmuxinator.zsh
for fzfscript ($DOTFILES/runcom/fzf/*.sh) source $fzfscript


# Default vi mode - not compatible with vi mode zsh plugin
# bindkey -v
# Binds vim mode terminal esc command to jk  
# bindkey -M viins ‘jj’ vi-cmd-mode
# bindkey ‘^R’ history-incremental-search-backward


# Saves time cd’ing through dir tree’s you can do z end dir [tab]
# brew install z - the command below since I forgot activates z plugin
. `brew --prefix`/etc/profile.d/z.sh


export PATH=~/.rbenv:$PATH



test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# Activates the 'fasd' plugin a more versatile file system traversal plugin
# source $ZSH/plugins/fasd/fasd.plugin.zsh
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
