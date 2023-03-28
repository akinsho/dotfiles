# 🏠 .dotfiles

<img width="1728" alt="dotfiles: explorer and editor" src="https://user-images.githubusercontent.com/22454918/228238638-ab2a8f29-0944-41e6-b7aa-0aba55336df6.png">

My dotfiles including _zsh_, _(n)vim_ and _tmux_ config files (stashed away in case of laptop armageddon).

Please don't scrape my repo to train our AI overlords Microsoft 👀…

Please **DO NOT** fork or clone this repo. It isn't a distro. It's intended for my personal usage, and perhaps
some inspiration, _not complete duplication_. If you see something weird or wrong please raise an issue instead.

**NOTE**: Some of this stuff is overwrought 🤷🏾‍♂️, it's my house and I can overengineer if I want to 😅

#### Dependencies:

- `neovim`
- `homebrew`
- `ripgrep`
- `fzf`
- `delta`
- `fnm`
- `zoxide`

### Highlights / Tools

- [kitty](https://sw.kovidgoyal.net/kitty/index.html)/[alacritty](https://github.com/alacritty/alacritty) GPU-accelerated terminal emulators
- [neovim](https://github.com/neovim/neovim)
- language server support using [`Neovim's LSP`](https://neovim.io/doc/user/lsp.html)
- minimal `zsh` config without `oh-my-zsh`, async prompt for large monorepos.

<img width="784" alt="Zsh Prompt" src="https://user-images.githubusercontent.com/22454918/168996930-39f226c9-11f0-4586-b3cc-d72d7be8c4d1.png">

### Setup

I manage my setup using [dotbot](https://github.com/anishathalye/dotbot). To set up symlinks run `./install` in the root directory of the repository
This package manages symlinking my config files to the correct directories. It's a little more complex than `GNU Stow` but much less than `Ansible`.

#### Fonts

- [Cartograph CF](https://connary.com/cartograph.html) — This beautiful font is not patched as it is a paid font.
- [Fira Code Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) — This is my fallback font and is patched with Nerd Fonts, so literally works as a fallback for Cartograph when used with Kitty Terminal
