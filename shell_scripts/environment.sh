#!/usr/bin/zsh

#=======================================================================
#       ENV VARIABLES
#=======================================================================
# NB for future notice this tries to install in dotfiles unless explicitly
# specified here
export NVM_DIR="$HOME/.nvm"
export DOTFILES=$HOME/Dotfiles
export RUNCOM=$DOTFILES/runcom/
export PATH="$PATH:$(yarn global bin)"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.node/bin:$HOME/.rbenv/shims:$PATH

# GO ============================================================
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export PATH=$PATH:/usr/local/go/bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  export GOPATH=$HOME/Desktop/Coding/Go
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
  export PATH=$PATH:$(go env GOPATH)/bin

  # # Android SDK
  # export ANDROID_HOME=$HOME/Library/Android/sdk
  # export PATH=$PATH:$ANDROID_HOME/tools
  # export PATH=$PATH:$ANDROID_HOME/platform-tools
fi
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# RUBY ==========================================================
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Setting from Chrome Driver on MacOS
export {no_proxy,NO_PROXY}="127.0.0.1,localhost"

export MANPATH="/usr/local/man:$MANPATH"
export PATH=~/.rbenv:$PATH

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

source $HOME/.environment.secret.sh
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

export ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

# opam configuration
test -r /home/akin/.opam/opam-init/init.zsh && . /home/akin/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
