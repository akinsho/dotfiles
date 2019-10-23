# Dotfiles

My dotfiles including Zsh, Vim and Tmux config files (stashed away in case of laptop Armageddon).

I thought I'd document for myself and for others potentially some of the setup
involved in the various programs my dotfiles cover. I'm no pro and some of
this stuff has worked for me but may not be universal.

### Setup

Having recently had to setup my mac multiple times in a short period of time
I recently rediscovered the importance of having a check-list for the setup
process

- Clone Dotfiles repo into the HOME directory or get hold of the install script in the dotfiles repo
- Run `./install.sh` (with or without a `minimal` flag) **WIP**

### Organisation

After struggling with a 2500+ line long `init.vim` I finally decided to bite the
bullet and modularise my `init.vim`.

Having taken a look at several patterns on line I decided on the following approach
My `init.vim` is essentially a hub of links to the various sections of my configuration.

These are divided into:

- Autocommands
- Mappings
- General settings
- Plugins (home made or stolen vimscript)

I then further modularised/succumbed to the Internet's suggestion to avoid
over using Autocommands and use **Vim's after** directory.

Small explainer if this is news to you. Vim loads different files depending on their location in its directory, for example autoloading scripts load on
demand/lazily. Filetype plugins run when a file type is opened. `after/ftplugins` do open after plugins and regular filetype
files have run.

This lets me have the last word on the settings per filetype after the plugins
have run and the filetype files from Vim so my settings definitely show up.

```vim
  .vim/
    autoload/
    ftplugin/
    plugged/ [vim-plug]
    plugins/
    bundle/
    after/
      /ftplugins
        /myFile
```

### Autoload Directory

As I mentioned above this directory allows a Vim user
to lazy load utility functions which given the number
and size of a users functions can improve startup.

In my case I've manually symlinked the autoload script
into then `~/.config/nvim/autoload` directory and
`~/.vim/autoload/` directory.

N.B. A better solution would be have the entire Neovim directory be a symlink to the vim
directory to prevent having to manage and symlink to both.

### Great Plugins

List of plugins I don't want to forget exist

- `Plug 'MattesGroeger/vim-bookmarks'`
- `Plug 'ap/vim-buftabline'`
- `Plug 'wikitopian/hardmode'`
- `Plug 'machakann/vim-highlightedyank'`
- `Plug 'kana/vim-smartword'`
- `Plug 'bkad/CamelCaseMotion`

### Excellent Colorschemes

- `Plug 'davidklsn/vim-sialoquent'`
- `Plug 'joshdick/onedark.vim'`
- `Plug 'trevordmiller/nova-vim'`
- `Plug 'kristijanhusak/vim-hybrid-material'`
- `Plug 'tyrannicaltoucan/vim-quantum'`

### Tmux

Tmux is an amazing development tool, it is a `terminal multiplexer`. Which is matrix
speak for saying it lets you have multiple terminal splits and windows all within _multiple_
sessions, all within a single actual terminal pane (...inception...). It's easier seen than
described.
Here be a Giant rabbit hole you have been warned.

### _Italics_ in _TMUX_

- Firstly you need to create a `$HOME/terminfo` folder.
- Anywhere else (**not inside this folder**) you need to create a `tmux.terminfo`
  file, a `tmux-256color.terminfo` file and an `xterm-256color.terminfo` file.
- Finally run the command
  NB. The advice I have seen given multiple times is to use the commands below.
  Although a recent laptop setup proved unsuccessful using these command. I'll
  leave them for future reference but what I in fact used successfully were :-

```sh
/Dotfiles/configs/
tic xterm-256color.terminfo
tic tmux-256color.terminfo
```
