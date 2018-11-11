# Linux Setup documenation

- Symlink `$DOTFILES/linux/.zshrc-Linux.zsh` to `~/.zshrc-Linux`.

  - N.B. This probably doesn't need to be symlinked or maybe each platform should have it's own `zshrc`.

- Install `xcape` using package manager (`pacman`, `apt`).
- Add the following to `~/.profile` to allow the `caps lock` key to work as `esc` and `ctrl` this is helpful for using `vim`.

```sh
setxkbmap -option ctrl:swapcaps
xcape -e 'Control_L=Escape'
```

[Reference](https://www.reddit.com/r/linux/comments/5h63js/anyway_to_remap_caps_lock_to_be_both_escape_and/)

- Manually add emoji font (if using arch based distro) - `sudo pacman -S noto-fonts-emoji` (currently a feature request to have this by default on `Manjaro`)

- Also add emoji keyboard - this will be in the install script
