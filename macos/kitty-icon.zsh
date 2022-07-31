cp $SYNC_DIR/kitty/icons/kitty-light.icns /Applications/kitty.app/Contents/Resources/kitty.icns
rm /var/folders/*/*/*/com.apple.dock.iconcache
touch /Applications/kitty.app
killall Dock && killall Finder
