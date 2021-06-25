#!/usr/bin/env sh

# Reference: https://bbs.archlinux.org/viewtopic.php?id=163075
# This script runs pacman with sudo only if required
pacman() {
    case $1 in
        -S | -D | -S[^sih]* | -R* | -U*)
            /usr/bin/sudo /usr/bin/pacman "$@" ;;
    *)      /usr/bin/pacman "$@" ;;
    esac
}

# https://www.addictivetips.com/ubuntu-linux-tips/back-up-the-gnome-shell-desktop-settings-linux/
backup-gnome() {
    dconf dump / > $HOME/Dropbox/gnome/dconf-settings.ini
    tar -cpf icons.tar.gz --absolute-names ~/.icons
    tar -cpf themes.tar.gz --absolute-names ~/.themes
    mv --force *.tar.gz $HOME/Dropbox/gnome/
}

restore-gnome() {
    dconf load / < $HOME/Dropbox/gnome/dconf-settings.ini
    tar --extract --file $HOME/Dropbox/gnome/icons.tar.gz -C ~/ --strip-components=2
    tar --extract --file $HOME/Dropbox/gnome/themes.tar.gz -C ~/ --strip-components=2
}

build-nvim() {
    neovim_dir="$PROJECTS_DIR/contributing/neovim"
    [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
    pushd $neovim_dir
    git checkout master
    git pull origin master
    [ -d "$neovim_dir/build/" ] && rm -r ./build/  # clear the CMake cache
    make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
    make install
    popd
}
