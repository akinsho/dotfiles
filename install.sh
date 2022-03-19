#!/bin/sh

# add required dependencies
# * GCC
# * python
# * delta
# * bat
# * thefuck

packages=(
  "curl",
  "git",
  "gcc",
  "delta",
  "bat",
  "thefuck",
  "python"
  "zoxide"
  "lazygit"
  "ripgrep"
)

exists() {
  type "$1" &> /dev/null;
}

install_missing_packages() {
  for p in "${packages[@]}"; do
    if hash "$p" 2>/dev/null; then
      echo "$p is installed"
    else
      echo "$p is not installed"
      # Detect the platform (similar to $OSTYPE)
      OS="`uname`"
      case $OS in
        'Linux')
          apt install "$1" || echo "$p failed to install"
          ;;
        'Darwin')
          brew install "$1" || echo "$p failed to install"
          ;;
        *) ;;
      esac
      echo "---------------------------------------------------------"
      echo "Done "
      echo "---------------------------------------------------------"
    fi
  done
}


create_dir() {
  if [ ! -d "$1" ]; then
    echo "Creating $1"
    mkdir -p $1
  fi
}

# Might as well ask for password up-front, right?
echo "Starting install script, please grant me sudo access..."
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ "$(uname)" == "Darwin" ]; then
  brew="/usr/local/bin/brew"
  if [ -f "$brew" ]; then
    echo "Homebrew is installed, nothing to do here"
  else
    echo "Homebrew is not installed, installing now"
    echo "This may take a while"
    echo "Homebrew requires osx command lines tools, please download xcode first"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
fi

install_missing_packages || echo "failed to install missing packages"

# Clone my dotfiles repo into ~/.dotfiles/ if needed
echo "---------------------------------------------------------"
echo "dotfiles"
echo "---------------------------------------------------------"

export DOTFILES="$HOME/.dotfiles"

if [ -f "$DOTFILES" ]; then
  echo "Dotfiles have already been cloned into the home dir"
else
  echo "Cloning dotfiles"
  git clone https://github.com/akinsho/dotfiles.git ~/.dotfiles
fi

cd "$DOTFILES" || "Didn't cd into dotfiles this will be bad :("
git submodule update --init --recursive

cd "$HOME" || exit
echo "---------------------------------------------------------"
echo "You'll need to log out for this to take effect"
echo "---------------------------------------------------------"

if [ "$(uname)" == "Darwin" ]; then
echo "---------------------------------------------------------"
echo "running macos defaults"
echo "this may take a while.. as well"
echo "---------------------------------------------------------"
  source "$DOTFILES/configs/macos/install.sh"
  echo "Installing brew bundle"
  brew tap Homebrew/bundle
  brew bundle --global
  echo "Installing Homebrew apps from Brewfile"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install n node version manager program
curl -L https://git.io/n-install | bash

# Install rust
curl https://sh.rustup.rs -sSf | sh

# These are handled by homebrew on macos
if [ "$(uname)" == "Linux" ]
  if exists cargo; then
    cargo install stylua
    cargo install git-delta
    cargo install topgrade
    # cargo install cargo-update # requires libopenssl-dev on ubuntu

  # install ripgrep via cargo in case it failed via apt or brew
  if ! exists rg; then
    cargo install ripgrep
  fi
  fi
fi

# TODO install
# * lazygit for linux

# TODO pip3 dependencies
# * pip3 install neovim --upgrade
# * pip3 install --user neovim-remote

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "---------------------------------------------------------"
echo "Changing to zsh"
echo "---------------------------------------------------------"
chsh -s "$(which zsh)"

$DOTFILES/install

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
