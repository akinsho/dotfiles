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
export CLICOLOR=1 # enable color support for ls.
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

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
#-------------------------------------------------------------------------------
# Go
#-------------------------------------------------------------------------------
export GOPATH=$HOME/go
#-------------------------------------------------------------------------------

path+=(
  /usr/local/bin
  ${HOME}/.npm/bin(N-/)
  ${HOME}/.local/bin(N-/)
  ${GOPATH}/bin(N-/)
  # Add local build of neovim to path for development
  ${HOME}/nvim/bin(N-/)
  # package manager for neovim
  ${HOME}/.local/share/bob/nvim-bin(N-/)
)


case `uname` in
  Darwin)
    export ANDROID_SDK_ROOT=${HOME}/Library/Android/sdk/
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
export VISUAL="nvim --cmd 'let g:flatten_wait=1'"
export EDITOR="nvim"

export USE_EDITOR=$EDITOR

if [ -f "$HOME/.environment.secret.sh" ]; then
  source $HOME/.environment.secret.sh
fi

if [ -f "$HOME/.environment.local.sh" ]; then
  source $HOME/.environment.local.sh
fi

export SSH_KEY_PATH="~/.ssh/rsa_id"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

#-------------------------------------------------------------------------------
#  FZF Settings
#-------------------------------------------------------------------------------
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_OPTS="--reverse \
--cycle \
--bind=esc:abort \
--height 60% \
--border sharp \
--prompt '∷ ' \
--marker ' ' \
--pointer ▶ "

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_TMUX_OPTS='-p80%,60%'
