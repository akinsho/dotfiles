# Linux Setup documentation

## Helpful Tips

To restore a buggered boot i.e. not booting into gui
press `e` on when the grub screen appears and add `3` (with a
space) to the line beginning with `linux` (has the boot options)
and restart. The next restart will boot into the commandline so
hopefully you can recover from your ("clever" tweaking)

## Hardware (Distro: Manjaro - as of 2018) -

### Dell XPS 15 (9570)

- Make sure boot usb detects the SSD Drive switch
  boot option from `RAID ON` to `AHCPI` by opening up
  UEFI settings (`ctrl-F12` repeatedly on boot)
- Disable Secure boot

* Symlink `$DOTFILES/linux/.zshrc-Linux.zsh` to `~/.zshrc-Linux`.

  - N.B. This probably doesn't need to be symlinked or maybe each platform should have it's own `zshrc`.

* Install `xcape` using package manager (`pacman`, `apt`).
* Add the following to `~/.profile` to allow the `caps lock` key to work as `esc` and `ctrl` this is helpful for using `vim`.

```sh
setxkbmap -option ctrl:swapcaps
xcape -e 'Control_L=Escape'
```

Note you can find key details like your wireless cards IF or port number, what drivers you are
using, the state of your battery etc. by running `inxi -Fxz`

[Reference](https://www.reddit.com/r/linux/comments/5h63js/anyway_to_remap_caps_lock_to_be_both_escape_and/)

- _INSTALL SCRIPT_ Add emoji font (if using arch based distro) - `sudo pacman -S noto-fonts-emoji` (currently a feature request to have this by default on `Manjaro`)

# Gnome Extensions

(N.B: figure out how to automate this)

- emoji-selector
- dash-to-dock
- transparent gnome panel
- caffeine
