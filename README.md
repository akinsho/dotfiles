# Dotfiles
My Various zsh/bash(coming soon), vim and Tmux config files (stashed away in case of laptop armageddon).

I plan on adding an install script as well as macos preferences either saved using mackup or getting the terminal defaults.


I thought I'd document for myself and for others potentially some of the setup
involved in the various programs my dotfiles cover. I'm no pro and some of
this stuff has worked for me but may not be universal.
## Tmux Setup

*italics*
===
Okay so firstly that was awesome, not for you, for me as I just wrote that
using *vim inside of tmux* and let me tell you that was no easy feat (the
setup I mean not the typing).

* Firstly you need to create a `$HOME/terminfo` folder.
* Anywhere else (**not inside this folder**) you need to create a `tmux.terminfo`
    file, a `tmux-256color.terminfo` file and an `xterm-256color.terminfo` file.
* Finally run the command 
```
tic -o /path/to/terminfo_folder /path/to/xterm-256color.terminfo/
tic -o /path/to/terminfo_folder /path/to/tmux-256color.terminfo/
tic -o /path/to/terminfo_folder /path/to/tmux.terminfo/
```
