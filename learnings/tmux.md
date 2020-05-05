### _Italics_ in _TMUX_

- Firstly you need to create a `$HOME/terminfo` folder.
- Anywhere else (**not inside this folder**) you need to create a `tmux.terminfo`
  file, a `tmux-256color.terminfo` file and an `xterm-256color.terminfo` file.
- Finally run the command
  NB. The advice I have seen given multiple times is to use the commands below.
  Although a recent laptop setup proved unsuccessful using these command. I'll
  leave them for future reference but what I in fact used successfully were :-

```sh
/.dotfiles/configs/
tic xterm-256color.terminfo
tic tmux-256color.terminfo
```
