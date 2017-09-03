#!/bin/sh

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

packages=(
"git"
"node"
"tmux"
"lua"
"neovim"
"vim"
"node"
)

for i in "${packages[@]}"
do
  "brew install $i"
  echo "---------------------------------------------------------"
done

echo "installing RCM, for dotfiles management"
brew tap thoughtbot/formulae
brew install rcm
echo "Installing brew bundle"
brew tap Homebrew/bundle
echo "---------------------------------------------------------"

localGit="/usr/local/bin/git"
if [ -f "$localGit" ]
then
  echo "git is all good"
else
  echo "git is not installed"
fi
# Okay so everything should be good
# Fingers cross at least
# Now lets clone my dotfiles repo into ~/Dotfiles/
echo "---------------------------------------------------------"

echo "Cloning Akin's dotfiles into Dotfiles"
git clone https://github.com/Akin909/Dotfiles.git ~/Dotfiles
export DOTFILES="$HOME/Dotfiles"
cd Dotfiles || "Didn't cd into dotfiles this will be bad :("
git submodule update --init --recursive

"cd $HOME"
echo "running RCM's rcup command"
echo "This is symlink the rc files in Dotfiles"
echo "with the rc files in $HOME"
echo "---------------------------------------------------------"

rcup

echo "---------------------------------------------------------"

echo "Changing to zsh"
"chsh -s $(which zsh)"

echo "You'll need to log out for this to take effect"
echo "---------------------------------------------------------"

echo "running macos defaults"
"cd $DOTFILES || echo 'Oh god didn't cd exiting || exit"
./configs/macosdefaults.sh
"cd $DOTFILES/configs/homebrew/ || echo 'Could get into Homebrew subdir'"
brew bundle
echo "Installing Homebrew apps from brew file"

echo 'done'
echo "---------------------------------------------------------"
echo "All done!"
echo "and change your terminal font to Operator mono book or lig"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
