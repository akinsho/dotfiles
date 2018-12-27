#!/bin/sh

# Might as well ask for password up-front, right?
echo "Starting install script, please grant me sudo access..."
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew="/usr/local/bin/brew"

if [ -f "$brew" ]
then
  echo "Homebrew is installed, nothing to do here"
else
  echo "Homebrew is not installed, installing now"
  echo "This may take a while"
  echo "Homebrew requires osx command lines tools, please download xcode first"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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

echo "Installing brew bundle"
brew tap Homebrew/bundle

# Clone my dotfiles repo into ~/Dotfiles/ if needed
echo "DOTFILES-------------------------------------------------"

export DOTFILES="$HOME/Dotfiles"

if [ -f "$DOTFILES" ]; then
  echo "Dotfiles have already been cloned into the home dir"
else
  echo "Cloning Akin's dotfiles into Dotfiles"
  git clone https://github.com/Akin909/Dotfiles.git ~/Dotfiles
fi

cd "$DOTFILES" || "Didn't cd into dotfiles this will be bad :("
git submodule update --init --recursive

cd "$HOME" || exit
echo "---------------------------------------------------------"

echo "You'll need to log out for this to take effect"

echo "running macos defaults"
echo "this may take a while.. as well"
echo "---------------------------------------------------------"

# shellcheck source=/Users/Akin/Dotfiles/configs/.macos
source "$DOTFILES/configs/.macos"

# If script is run as ./install.sh minimal
if [ "$1" == "minimal" ]; then
  echo "using minimal brew config"
  brew_directory="$DOTFILES/configs/homebrew/minimal/"
else
  brew_directory="$DOTFILES/configs/homebrew/"
fi

cd "$brew_directory" || echo "Couldn't get into Homebrew subdir"

brew bundle
echo "Installing Homebrew apps from brew file"

pip3 install neovim --upgrade

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

# link() {
#   target="$HOME/.config/$1"
#   if [ -e $target ]; then
#     echo "${target}" already exists
#   fi
# }

echo "Creating symlinks"
ln -sf "$DOTFILES/vim" ~/.config/nvim
ln -sf "$DOTFILES/zsh/.zplugrc" ~/.zshrc
ln -sf "$DOTFILES/configs/karabiner/" ~/.config/karabiner
ln -sf "$DOTFILES/configs/kitty" ~/.config/kitty
ln -sf "$DOTFILES/vim/init.vim" ~/.vimrc
ln -sf "$DOTFILES/configs/.hyper.js" ~/.hyper.js

ln -s "$DOTFILES/git/.gitconfig_global" ~/.gitconfig

echo "Adding Oni Config ----------------------------------------"
mkdir -p ~/.config/oni
ln -sf "$DOTFILES/vim/gui/config.tsx" ~/.config/oni/

git config --global core.excludesfile "$DOTFILES/git/.gitignore_global"

# Install rustup
curl https://sh.rustup.rs -sSf | sh

mkdir -p ~/Desktop/Coding

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
