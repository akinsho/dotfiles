#!/bin/sh

# Might as well ask for password up-front, right?
echo "Starting install script, please grant me sudo access..."
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ "$(uname)" == "Darwin" ]; then
  brew="/usr/local/bin/brew"
  if [ -f "$brew" ]
  then
    echo "Homebrew is installed, nothing to do here"
  else
    echo "Homebrew is not installed, installing now"
    echo "This may take a while"
    echo "Homebrew requires osx command lines tools, please download xcode first"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
fi

packages=("git" "node")

check_pkg_exists() {
  for p in "${packages[@]}"; do
    if hash "$p" 2>/dev/null
    then
      echo "$p is installed"
    else
      echo "$p is not installed"
      brew install "$p"
      echo "---------------------------------------------------------"
    fi
  done
}

check_pkg_exists

npm_install() {
  if hash npm 2>/dev/null;then
    npm i -g "$@"
  else
    echo "npm command does not exist"
  fi
}

# Clone my dotfiles repo into ~/.dotfiles/ if needed
echo "dotfiles -------------------------------------------------"

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

echo "running macos defaults"
echo "this may take a while.. as well"
echo "---------------------------------------------------------"

if [ "$(uname)" == "Darwin" ]; then
  source "$DOTFILES/configs/.macos"

  echo "Installing brew bundle"
  brew tap Homebrew/bundle

  cd "$DOTFILES/.config/homebrew/" || echo "Couldn't get into Homebrew subdir"

  brew bundle
  echo "Installing Homebrew apps from brew file"
fi

# pip3 install neovim --upgrade

# Install n node version manager program
curl -L https://git.io/n-install | bash
# Install rust
curl https://sh.rustup.rs -sSf | sh

echo "---------------------------------------------------------"
echo "Changing to zsh"
chsh "$(which zsh)"

echo "Creating .config dir if necessary -----------------------"
if [ ! -d "$HOME/.config" ]; then
  echo "Creating ~/.config"
  mkdir -p "$HOME/.config"
fi

$DOTFILES/install

mkdir -p ~/Desktop/projects/

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
