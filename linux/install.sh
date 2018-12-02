link() {
  ln -sf $1 $2
}

DOTFILES='~/Dotfiles'
LINUXDIR='~/Dotfiles/linux'

# Create the nvim dir and symlink vim dir to it 
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
link ~/.vim $XDG_CONFIG_HOME/nvim
link ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

sudo sh
pacman -S noto-fonts-emoji
pacman -S nodejs
pacman -S yarn
pacman -S hub
yarn global add bs-platform
yarn global add esy

link $LINUXDIR/conky/minimal-info/minimal-info.lua ~/.conkyrc
link $LINUXDIR/conky/minimal-info/utils.lua ~/
link $LINUXDIR/.zshrc-Linux.zsh ~/.zshrc
