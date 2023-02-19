# .dotfiles

<img width="1728" alt="dotfiles" src="https://user-images.githubusercontent.com/22454918/183880278-d9762976-07a9-457e-8542-d2685a8a26b4.png">

My dotfiles including _zsh_, _(n)vim_ and _tmux_ config files (stashed away in case of laptop armageddon).

I thought I'd document for myself and for others potentially some of the setup
involved in the programs my dotfiles cover.

Please **DO NOT** fork or clone this repo. It isn't a distro it's intended for my personal usage, and perhaps
some inspiration, _not complete duplication_. If you see something weird or wrong please raise an issue instead.

### Installation

The installation script is out of date and doesn't work anymore.
To set up a new machine instead follow these instructions:

1. Check `git` is installed.
2. (macOS) Install homebrew using the most recent instructions.

#### dependencies:

- `neovim`
- `homebrew` (macOS)
- `ripgrep`
- `fzf`
- `delta`
- `prettier`
- `stylua`

### Highlights / Tools

- [Kitty](https://sw.kovidgoyal.net/kitty/index.html)/[Alacritty](https://github.com/alacritty/alacritty) GPU-accelerated terminal emulators
- [Nvim](https://github.com/neovim/neovim)
- Language server support using [`Neovim's LSP`](https://neovim.io/doc/user/lsp.html)

- Minimal Zsh config without `oh-my-zsh`, async prompt for large monorepos.

<img width="784" alt="Zsh Prompt" src="https://user-images.githubusercontent.com/22454918/168996930-39f226c9-11f0-4586-b3cc-d72d7be8c4d1.png">

### Setup

I manage my setup using [dotbot](https://github.com/anishathalye/dotbot). To set up symlinks run
`./install` in the root directory of the repository

This package manages symlinking my config files to the correct directories.
It's a little more complex than `GNU Stow` but much less than `Ansible`

#### Fonts

- [Cartograph CF](https://connary.com/cartograph.html) — This beautiful font is not patched as it is a paid font.
- [Fira Code Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) — This is my fallback font and is patched with Nerd Fonts, so literally works as a fallback for Cartograph when used with Kitty Terminal
