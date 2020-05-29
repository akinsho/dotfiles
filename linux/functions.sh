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

backup-gnome() {
    dconf dump / > $HOME/Dropbox/gnome/dconf-settings.ini
}

restore-gnome() {
    dconf load / < $HOME/Dropbox/gnome/dconf-settings.ini
}
