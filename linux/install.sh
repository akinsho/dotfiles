link() {
  ln -sf $1 $2
}

LINUXDIR=$DOTFILES/linux

# Create the nvim dir and symlink vim dir to it
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
link ~/.vim $XDG_CONFIG_HOME/nvim
link ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

sudo sh
pacman -S noto-fonts-emoji
pacman -S nodejs
pacman -S yarn
pacman -S hub
yarn global add esy

# after  installing node take ownership of its directories
sudo chown -R $(whoami) /usr/local/lib/node_modules
sudo chown -R $(whoami) /usr/local/bin
sudo chown -R $(whoami) /usr/local/share

link $LINUXDIR/conky/minimal-info/minimal-info.lua ~/.conkyrc
link $LINUXDIR/conky/minimal-info/utils.lua ~/
link $LINUXDIR/.zshrc-Linux.zsh ~/.zshrc
