# Dotfiles
My dotfiles including zsh, vim and Tmux config files (stashed away in case of laptop armageddon).

I thought I'd document for myself and for others potentially some of the setup
involved in the various programs my dotfiles cover. I'm no pro and some of
this stuff has worked for me but may not be universal.


# My Setup

After struggling with a 2500+ line long vimrc I finally decided to bite the
bullet and modularise my vimrc.

Having taken a look at several patterns on line I decided on the following approach
My `init.vim` is essentially a hub of links to the various sections of my
configuration.

These are divided into
* Autocommands
* Mappings
* General settings
* Plugins (home made or stolen vimscript)

I then further modularised/succumbed to the internet's suggestion to avoid
over using Autocommands and use **vim's after** directory.

Small explainer if this news to you. Vim loads different files depending on the location in its directory, for example autoloading scripts load on
demand/lazily. ftplugins run when a file type is opened. `after/ftplugins` do
what you might think. AKA open after plugins and regular filetype
files have run.

This lets me have the last word on the settings per file type after the plugins
have run and the ft files from vim so my settings definitely show up.

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


## Amazing Tools
1. **Vimr** - An absolutely astounding project to create a gui for neovim. It's
   a wonder to behold and really hits the nail on the head although its still
   new so not perfect but is under active development. Has file browser
   markdown preview etc.

2. **Oni** - Another perphaps even more spectacular GUI for neovim, featuring a very modern ui with completion menus, find in project menus etc.

2. [Karabiner-elements](https://github.com/tekezo/Karabiner-Elements) - Well
   known tool which has been remade for macOS Sierra which allows remapping keys, so
   you can do cool things like make the capslock key return an escape if
   pressed alone otherwise it returns control.



### Great Plugins
   So My Vimrc is arguably overloaded with plugins so I've decided to make
   a little list of plugins I use which I find really helpful but am currently
   not using/am using but may not be depending on my mood just to get back into the feel of doing these things without these
   awesome tools.

   * The syntax highlighting wars continue - `Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx']}`
   * Database manipulation in vim - `Plug 'vim-scripts/dbext.vim'`
   * `Plug 'MattesGroeger/vim-bookmarks'`
   * `Plug 'tiagofumo/vim-nerdtree-syntax-highlight'`
   * `Plug 'ap/vim-buftabline'`
   * Colors for hexcode in vim `Plug 'gorodinskiy/vim-coloresque', {'for': ['css', 'scss']}` - really great idea incredibly slow sadly
   * `Plug 'lifepillar/vim-cheat40'`
   * `Plug 'wikitopian/hardmode'`
   * `Plug 'michaeljsmith/vim-indent-object`
   * `Plug 'rhysd/committia.vim'`
   * `Plug 'machakann/vim-highlightedyank'`
   * `Plug 'jodosha/vim-godebug'`
   * `Plug 'gwutz/vim-materialtheme'`
   * `Plug 't9md/vim-choosewin', {'on': '<Plug>(choosewin)' }`
   * `Plug 'lambdalisue/gina.vim'`
   * `Plug 'paulhybryant/vim-textobj-path'`
   * `Plug 'kana/vim-smartword'`
   * `Plug 'low-ghost/nerdtree-fugitive'  "Fugitive capability in nerd tree`
   * `Plug 'kopischke/vim-fetch' "Allows GF to open vim at a specific line`
   * `Plug 'editorconfig/editorconfig-vim'`
   * `Plug 'bkad/CamelCaseMotion`

   Autocompletion for css which auto expands, very cool idea
   although at present it clashes with other insert mode
   plugins
   * `Plug 'rstacruz/vim-hyperstyle', {'for': ['css', 'scss', 'sass', 'jsx', 'tsx']}`


### Excellent colorschemes
   * `Plug 'davidklsn/vim-sialoquent'`
   * `Plug 'joshdick/onedark.vim'`
   * `Plug 'trevordmiller/nova-vim'`
   * `Plug 'kristijanhusak/vim-hybrid-material'`
   * `Plug 'tyrannicaltoucan/vim-quantum'`

### Language plugins
   Since I have great aspirations to play with all the languages :smile: here are
   some plugins I'm keeping my eyes on

## Clojure
   *    `Plug 'tpope/vim-fireplace', { 'for': 'clojure' }`
   *    `Plug 'guns/vim-sexp'`
   *    `Plug 'guns/vim-clojure-highlight'`
   *    `let g:clojure_fold = 1`
   *    `let g:sexp_filetypes = ''`
   *    `Plug 'tpope/vim-salve'`
   *    `let g:salve_auto_start_repl = 1`

## Tmux Setup
   Tmux is an amazing dev tool, it is a `terminal multiplexer`. Which is matrix
   speech for saying it lets you have multiple terminal splits and windows,
   sessions all within a single actual terminal pane. It's easier seen than
   described.
   Here be a Giant rabbit hole you have been warned.

## *Italics*

   Okay so firstly that was awesome, not for you, for me as I just wrote that
   using *vim inside of tmux* and let me tell you that was no easy feat (the
       setup I mean not the typing).
   * Firstly you need to create a `$HOME/terminfo` folder.
   * Anywhere else (**not inside this folder**) you need to create a `tmux.terminfo`
   file, a `tmux-256color.terminfo` file and an `xterm-256color.terminfo` file.
   * Finally run the command
   N.B. The advice I have seen given multiple times is to use the commands below.
   although a recent laptop setup proved unsuccessful using these command. I'll
   leave them for future reference but what I in fact used successfully were :-

   ``` sh
   /Dotfiles/configs/
   tic xterm-256color.terminfo
   tic tmux-256color.terminfo
   ```
   Recommended but not working
   ```sh
   tic -o /path/to/terminfo_folder /path/to/xterm-256color.terminfo/
   tic -o /path/to/terminfo_folder /path/to/tmux-256color.terminfo/
   tic -o /path/to/terminfo_folder /path/to/tmux.terminfo/
```
