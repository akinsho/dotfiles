Dotfiles
===

My dotfiles including Zsh, Vim and Tmux config files (stashed away in case of laptop Armageddon).

I thought I'd document for myself and for others potentially some of the setup
involved in the various programs my dotfiles cover. I'm no pro and some of
this stuff has worked for me but may not be universal.

### Setup

Having recently had to setup my mac multiple times in a short period of time
I recently rediscovered the importance of having a check-list for the setup
process

*   Clone Dotfiles repo into the HOME directory or get hold of the install script in the dotfiles repo
*   Run `./install.sh` (with or without a `minimal` flag) [WIP]

### Organisation
After struggling with a 2500+ line long `init.vim` I finally decided to bite the
bullet and modularise my `init.vim`.

Having taken a look at several patterns on line I decided on the following approach
My `init.vim` is essentially a hub of links to the various sections of my configuration.

These are divided into:
*   Autocommands
*   Mappings
*   General settings
*   Plugins (home made or stolen vimscript)

I then further modularised/succumbed to the Internet's suggestion to avoid
over using Autocommands and use **Vim's after** directory.

Small explainer if this is news to you. Vim loads different files depending on their location in its directory, for example autoloading scripts load on
demand/lazily. Filetype plugins run when a file type is opened. `after/ftplugins` do open after plugins and regular filetype
files have run.

This lets me have the last word on the settings per file type after the plugins
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
`~/.vim/autoload/` directory. N.B. A better solution would
be have the entire Neovim directory be a symlink to the vim
directory to prevent having to manage and symlink to both.

### Great Plugins
List of plugins I don't want to forget exist

*   `Plug 'vim-scripts/dbext.vim'` - Database manipulation in vim 
*   `Plug 'MattesGroeger/vim-bookmarks'`
*   `Plug 'ap/vim-buftabline'`
*   `Plug 'lifepillar/vim-cheat40'`
*   `Plug 'wikitopian/hardmode'`
*   `Plug 'rhysd/committia.vim'`
*   `Plug 'machakann/vim-highlightedyank'`
*   `Plug 'jodosha/vim-godebug'`
*   `Plug 'paulhybryant/vim-textobj-path'`
*   `Plug 'kana/vim-smartword'`
*   `Plug 'low-ghost/nerdtree-fugitive'` - Fugitive capability in nerd tree
*   `Plug 'editorconfig/editorconfig-vim'`
*   `Plug 'bkad/CamelCaseMotion`

Autocompletion for CSS which auto expands, very cool idea
although at present it clashes with other insert mode
plugins
*   `Plug 'rstacruz/vim-hyperstyle', {'for': ['css', 'scss', 'sass', 'jsx', 'tsx']}`

### Excellent Colorschemes

*   `Plug 'davidklsn/vim-sialoquent'`
*   `Plug 'joshdick/onedark.vim'`
*   `Plug 'trevordmiller/nova-vim'`
*   `Plug 'kristijanhusak/vim-hybrid-material'`
*   `Plug 'tyrannicaltoucan/vim-quantum'`

### Tmux

Tmux is an amazing development tool, it is a `terminal multiplexer`. Which is matrix
speech for saying it lets you have multiple terminal splits and windows,
sessions all within a single actual terminal pane. It's easier seen than
described.
Here be a Giant rabbit hole you have been warned.

### _Italics_ in *TMUX*

*   Firstly you need to create a `$HOME/terminfo` folder.
*   Anywhere else (**not inside this folder**) you need to create a `tmux.terminfo`
    file, a `tmux-256color.terminfo` file and an `xterm-256color.terminfo` file.
*   Finally run the command
    NB. The advice I have seen given multiple times is to use the commands below.
    Although a recent laptop setup proved unsuccessful using these command. I'll
    leave them for future reference but what I in fact used successfully were :-


```sh
/Dotfiles/configs/
tic xterm-256color.terminfo
tic tmux-256color.terminfo
```
