#!/usr/bin/env sh

# https://www.addictivetips.com/ubuntu-linux-tips/back-up-the-gnome-shell-desktop-settings-linux/
backup-gnome() {
    dconf dump / > ${SYNC_DIR}/gnome/dconf-settings.ini
    tar -cpf icons.tar.gz --absolute-names ~/.icons
    tar -cpf themes.tar.gz --absolute-names ~/.themes
    mv --force *.tar.gz ${SYNC_DIR}/gnome/
}

restore-gnome() {
    dconf load / < ${SYNC_DIR}/gnome/dconf-settings.ini
    tar --extract --file ${SYNC_DIR}/gnome/icons.tar.gz -C ~/ --strip-components=2
    tar --extract --file ${SYNC_DIR}/gnome/themes.tar.gz -C ~/ --strip-components=2
}
