# Dotfiles
My dotfiles including zsh, vim and Tmux config files (stashed away in case of laptop armageddon).

I plan on adding an install script as well as macos preferences either saved using mackup or getting the terminal defaults.

## Amazing Tools
A list of amazing tools I've discorvered but cannot hide away
1. **Vimr** - An absolutely astounding project to create a gui for neovim. It's
   a wonder to behold and really hits the nail on the head although its still
   new so not perfect but is under active developement. Has file broswer
   markdown preview etc.


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

### Great Plugins I've Abandoned for now
So My Vimrc is arguably overloaded with plugins so I've decided to make
a little list of plugins I use which I find really helpful but am currently
not using just to get back into the feel of doing these things without these
awesome tools

* Bookmarks for vim - `Plug 'MattesGroeger/vim-bookmarks'`
* The syntax highlighting wars continue - `Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx']}`
* Database manipulation in vim - `Plug 'vim-scripts/dbext.vim'`
* `Plug 'tiagofumo/vim-nerdtree-syntax-highlight'`
* `Plug 'bronson/vim-visual-star-search'`
*  Buffers in the tabline because ....why... tabs  `Plug 'ap/vim-buftabline'` - Think my pc is too encumbered for this plugin
* Colors for hexcode in vim `Plug 'gorodinskiy/vim-coloresque', {'for': ['css', 'scss']}` - really great idea incredibly slow sadly
#### Excellent colorschemes I'll definitely be trying again i'm just capricious
:shrug:
* vim sialoquent theme  `Plug 'davidklsn/vim-sialoquent'`
* OneDark  `Plug 'joshdick/onedark.vim'`

#### ...Easymotion....four plugins for the price of one, these are excellent regardless
* `Plug 'inside/vim-search-pulse'`
* `Plug 'haya14busa/incsearch.vim'`
* `Plug 'haya14busa/incsearch-fuzzy.vim'`
* `Plug 'haya14busa/incsearch-easymotion.vim'`
* `Plug 'lifepillar/vim-cheat40'`
* `Plug 'wikitopian/hardmode'`
