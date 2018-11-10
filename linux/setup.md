# Linux Setup documenation

- Symlink `$DOTFILES/linux/.zshrc-Linux.zsh` to `~/.zshrc-Linux`.

  - N.B. This probably doesn't need to be symlinked or maybe each platform should have it's own `zshrc`.

- Install `xcape` using package manager (`pacman`, `apt`).
- Add the following to `~/.profile` to allow the `caps lock` key to work as `esc` and `ctrl` this is helpful for using `vim`.

```sh
setxkbmap -option ctrl:swapcaps
xcape -e 'Control_L=Escape'
```
