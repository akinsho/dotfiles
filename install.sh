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

npm() {
  if hash npm 2>/dev/null;then
    npm i -g "$@"
  else
    echo "npm command does not exist"
  fi
}

echo "Installing brew bundle"
brew tap Homebrew/bundle
echo "---------------------------------------------------------"

# Okay so everything should be good
# Fingers cross at least
# Now lets clone my dotfiles repo into ~/Dotfiles/
echo "---------------------------------------------------------"

echo "Cloning Akin's dotfiles into Dotfiles"
git clone https://github.com/Akin909/Dotfiles.git ~/Dotfiles

export DOTFILES="$HOME/Dotfiles"
cd DOTFILES || "Didn't cd into dotfiles this will be bad :("
git submodule update --init --recursive

cd "$HOME" || exit
echo "---------------------------------------------------------"
echo "Changing to zsh"
chsh -s "$(which zsh)"

echo "You'll need to log out for this to take effect"
echo "---------------------------------------------------------"

echo "running macos defaults"

sudo "$DOTFILES/configs/.macos"

if [ "$1" == "minimal" ]; then
  echo "using minimal brew config"
  brew_directory="$DOTFILES/configs/homebrew/minimal/"
else
  brew_directory="$DOTFILES/configs/homebrew/"
fi

cd "$brew_directory" || echo "Couldn't get into Homebrew subdir"

brew bundle
echo "Installing Homebrew apps from brew file"

echo "Creating symlinks"
ln -s "$DOTFILES/vim/init.vim" ~/.vimrc
ln -s "$DOTFILES/oh-my-zsh/.zshrc" ~/.zshrc
ln -s "$DOTFILES/configs/karabiner/" ~/.config/karabiner
ln -s "$DOTFILES/git/.gitconfig_global" ~/.gitconfig

echo "Adding Oni Config"
mkdir -p ~/.config/oni
ln -sf "$DOTFILES/vim/config/gui/config.tsx" ~/.config/oni/

npm spaceship-prompt

mkdir -p ~/Desktop/Coding

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
