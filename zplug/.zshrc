#=======================================================================
#               STARTUP TIMES
#=======================================================================
# zmodload zsh/zprof
start_time="$(date +%s)"
#=======================================================================
#       ENV VARIABLES
#=======================================================================
# NB for future notice this tries to install in dotfiles unless explicitly
# specified here
export NVM_DIR="$HOME/.nvm"
export DOTFILES=$HOME/Dotfiles
export RUNCOM=$DOTFILES/runcom/
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PYENV_VIRTUAL_DISABLE_PROMPT=1
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.node/bin:$HOME/.rbenv/shims:$PATH

# GO ============================================================
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/Desktop/Coding/Go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$(go env GOPATH)/bin
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# RUBY ==========================================================
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export {no_proxy,NO_PROXY}="127.0.0.1,localhost"

# PLUGINS =======================================================================
# plugins=(
# zsh-syntax-highlighting
# alias-tips
# last-working-dir
# zsh-nvm
# jira
# vi-mode
# git
# gitfast
# zsh-completions
# command-not-found
# colored-man-pages
# z
# common-aliases
# brew
# zsh-autosuggestions
# zsh-iterm-touchbar
# )

# ZPLUG

source ~/.zplug/init.zsh

# Make sure to use double quotes
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/git-fast",   from:oh-my-zsh
zplug "plugins/last-working-dir", from:oh-my-zsh
zplug "plugins/jira", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "b4b4r07/enhancd", use:init.sh

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi


# Then, source plugins and add commands to $PATH
zplug load --verbose

export MANPATH="/usr/local/man:$MANPATH"
export PATH=~/.rbenv:$PATH

# Android SDK

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_144`

# you may need to manually set your language environment
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Change the path where project plugin creates projects
# export PROJECTS_HOME=~/Desktop/Coding
# Aliases 'hub' to git to allow for greater git powah!!
eval "$(hub alias -s)"
##---------------------------------------------------------------------------/
## NPX - AUTO-FALL-BACK COMMAND
##---------------------------------------------------------------------------///
source <(npx --shell-auto-fallback zsh)

#Pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"
# For a full list of active aliases, run `alias`.
#=======================================================================
#                 SPACESHIP THEME
#=======================================================================

# PROMPT
# ➔ - default arrow
# ➼ - fun alternative
# ➪ - fun alternative2
# SPACESHIP_PROMPT_SYMBOL='➜ 🍕 '
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true

# VI_MODE
SPACESHIP_VI_MODE_SHOW=true
SPACESHIP_VI_MODE_INSERT="[i]"
SPACESHIP_VI_MODE_NORMAL="[n]"
# GIT
SPACESHIP_GIT_PREFIX='  on '
SPACESHIP_GIT_STATUS_STASHED=' 💰 '
SPACESHIP_GIT_STATUS_UNTRACKED=' 😰 '

SPACESHIP_NODE_PREFIX=' @ '

SPACESHIP_PACKAGE_SHOW=false

SPACESHIP_RUBY_SHOW=false
# PYENV
SPACESHIP_PYENV_SHOW=   false
SPACESHIP_PYENV_SYMBOL='🐍'
export PYENV_VIRTUALENV_DISABLE_PROMPT=1


export GIT_UNCOMMITTED="+"
export GIT_UNSTAGED="!"
export GIT_UNTRACKED="?"
export GIT_STASHED="$"
export GIT_UNPULLED="⇣"
export GIT_UNPUSHED="⇡"
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
setopt autoparamslash       # tab completing directory appends a slash
setopt correct              # command auto-correction

# Share your history across all your terminal windows
setopt share_history
# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

export ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd"
##---------------------------------------------------------------------------//


if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

# EMOJI-CLI
if [ -f $ZSH_CUSTOM/plugins/emoji-cli/emoji-cli.zsh ]; then
  source $ZSH_CUSTOM/plugins/emoji-cli/emoji-cli.zsh
fi


#ENHANCD ================================================================
if [ -f ~/enhancd/init.sh ]; then
  # TODO add a check to see if script exists if not install it
  # Maybe try using zplug again
  source ~/enhancd/init.sh
else
  git clone https://github.com/b4b4r07/enhancd ~/enhancd
  source ~/enhancd/init.sh
fi

#=======================================================================
#   LOCAL SCRIPTS
#=======================================================================
# source all zsh and sh files inside dotfile/runcom
source $DOTFILES/runcom/functions.sh
source $DOTFILES/runcom/zsh/alias.sh
for fzfscript ($DOTFILES/runcom/fzf/*.sh) source $fzfscript
  for script ($DOTFILES/runcom/zsh/*) source $script
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
  eval "$(thefuck --alias)"
  alias fuckit='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'
  # iTERM Integration ==================================================
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

  autoload -U promptinit; promptinit
  # PURE_PROMPT_SYMBOL="•"
  prompt pure

  export JIRA_URL='https://yulife.atlassian.net'
  export JIRA_NAME='akin'
  export JIRA_RAPID_BOARD=true
  export JIRA_DEFAULT_ACTION='dashboard'

  ##---------------------------------------------------------------------------//
  # FZF
  ##---------------------------------------------------------------------------//
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

  # STARTUP TIMES (CONTD)================================================
  end_time="$(date +%s)"
  # Compares start time defined above with end time above and prints the
  # difference
  echo load time: $((end_time - start_time)) seconds
  ##---------------------------------------------------------------------------//
  # LOL
  ##---------------------------------------------------------------------------//
  # if brew ls --versions fortune > /dev/null;then
  #   runonce <(fortune | cowsay | lolcat)
  # fi
  # zprof
  archey -o

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
