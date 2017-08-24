# Dotfiles
My dotfiles including zsh, vim and Tmux config files (stashed away in case of laptop armageddon).

I plan on adding an install script as well as macos preferences either saved using mackup or getting the terminal defaults.

I thought I'd document for myself and for others potentially some of the setup
involved in the various programs my dotfiles cover. I'm no pro and some of
this stuff has worked for me but may not be universal.

## Amazing Tools
A list of amazing tools I've discorvered but cannot hide away
1. **Vimr** - An absolutely astounding project to create a gui for neovim. It's
   a wonder to behold and really hits the nail on the head although its still
   new so not perfect but is under active developement. Has file broswer
   markdown preview etc.

2. [Karabiner-elements](https://github.com/tekezo/Karabiner-Elements) - Well
   known tool which has been remade for macOS Sierra which allows remaping keys, so
   you can do cool things like make the capslock key return an escape if
   pressed alone otherwise it returns control.


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

### Great Plugins I've Abandoned for now
So My Vimrc is arguably overloaded with plugins so I've decided to make
a little list of plugins I use which I find really helpful but am currently
not using/am using but may not be depending on my mood just to get back into the feel of doing these things without these
awesome tools

* The syntax highlighting wars continue - `Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx']}`
* Database manipulation in vim - `Plug 'vim-scripts/dbext.vim'`
* `Plug 'MattesGroeger/vim-bookmarks'`
* `Plug 'tiagofumo/vim-nerdtree-syntax-highlight'`
* `Plug 'bronson/vim-visual-star-search'`
* `Plug 'ap/vim-buftabline'`
* Colors for hexcode in vim `Plug 'gorodinskiy/vim-coloresque', {'for': ['css', 'scss']}` - really great idea incredibly slow sadly
* `Plug 'lifepillar/vim-cheat40'`
* `Plug 'wikitopian/hardmode'`

### Excellent colorschemes
* `Plug 'davidklsn/vim-sialoquent'`
* `Plug 'joshdick/onedark.vim'`

### ...Easymotion....four plugins for the price of one, these are excellent regardless
* `Plug 'inside/vim-search-pulse'`
* `Plug 'haya14busa/incsearch.vim'`
* `Plug 'haya14busa/incsearch-fuzzy.vim'`
* `Plug 'haya14busa/incsearch-easymotion.vim'`
