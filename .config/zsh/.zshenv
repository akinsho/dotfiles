# vim:ft=zsh
#-------------------------------------------------------------------------------
#       ENV VARIABLES
#-------------------------------------------------------------------------------
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
#  t   : tail of the path
# CREDIT: @ahmedelgabri
#--------------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

export SYNC_DIR=${HOME}/Dropbox
export DOTFILES=${HOME}/.dotfiles
export PROJECTS_DIR=${HOME}/projects
export PERSONAL_PROJECTS_DIR=${PROJECTS_DIR}/personal

# @see: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
if which rg >/dev/null; then
  export RIPGREP_CONFIG_PATH=${DOTFILES}/.config/rg/.ripgreprc
fi

# Added by n-install (see http://git.io/n-install-repo).
if [ -d "$HOME/n" ]; then
  export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NOTE: for signing commits with GPG (for work)
export GPG_TTY=$(tty)
#-------------------------------------------------------------------------------
# Go
#-------------------------------------------------------------------------------
export GOPATH=$HOME/go
#-------------------------------------------------------------------------------

path+=(
  /usr/local/bin
  ${HOME}/.npm/bin(N-/)
  ${HOME}/.local/bin(N-/)
  # Dart -----------------------------------------------------------------------
  ${HOME}/flutter/.pub-cache/bin(N-/)
  ${HOME}/flutter/bin(N-/)
  ${HOME}/.pub-cache/bin(N-/)
  ${GOPATH}/bin(N-/)
  # Add local build of neovim to path for development
  ${HOME}/nvim/bin(N-/)
)


case `uname` in
  Darwin)
    export ANDROID_SDK_ROOT=${HOME}/Library/Android/sdk/
  ;;
  Linux)
  # Java -----------------------------------------------------------------------
  # Use Java 8 because -> https://stackoverflow.com/a/49759126
  # ------------------------------------------------------------------------
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
  path+=(
    ${JAVA_HOME}/bin(N-/)
  )
  ;;
esac

export MANPATH="/usr/local/man:$MANPATH"
if which nvim >/dev/null; then
  export MANPAGER='nvim +Man!'
fi

# you may need to manually set your language environment
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

# preferred editor for local and remote sessions
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
  export VISUAL="nvim"
  export EDITOR="nvim"
fi

export USE_EDITOR=$EDITOR

if [ -f "$HOME/.environment.secret.sh" ]; then
  source $HOME/.environment.secret.sh
fi

if [ -f "$HOME/.environment.local.sh" ]; then
  source $HOME/.environment.local.sh
fi

export SSH_KEY_PATH="~/.ssh/rsa_id"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf_history"

# To apply to the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Don't open FZF in a separate split in tmux
export FZF_TMUX=0
