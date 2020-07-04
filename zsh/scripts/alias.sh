# =============================================================================
# Aliases
# =============================================================================
alias ls="ls --color=auto"
alias top="vtop"
alias x="exit" # Exit Terminal
alias t=_t
alias del="rm -rf"
alias dots="cd $DOTFILES"
alias coding="cd ~/Desktop/Coding"
alias lp="lsp"
alias v='nvim'
alias minimalvim="nvim -u $DOTFILES/.config/nvim/minimal.vim"
alias vi='vim'
alias nv='nvim'
alias cl='clear'
alias restart="exec $SHELL"
alias src='restart'
alias dnd='do-not-disturb toggle'
alias ez="nvim ~/.zshrc"
alias ev="nvim ~/.vimrc"
alias et="nvim ~/.tmux.conf"
alias ns="clear && npm start"
alias nt="clear && npm test"
alias yt="clear && yarn test"
alias ys="clear && yarn start"

alias esy="nocorrect esy"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tkss="killall tmux"
alias tkill="tmux kill-session -t"
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# suffix aliases set the program type to use to open
# a particular file with an extension
alias -s js=nvim
alias -s html=nvim
alias -s css=nvim

alias serve='python -m SimpleHTTPServer'
alias fuckit='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'

if which kitty >/dev/null; then
  alias icat="kitty +kitten icat"
fi

if [[ `uname` == 'Linux' ]]; then
  # https://stackoverflow.com/questions/53298843/how-do-i-install-bundletool
  alias bundletool='java -jar ~/bundletool-all.jar'
  alias o='a -e xdg-open' # quick opening files with xdg-open
  alias open='xdg-open'

elif [[ `uname` == 'Darwin' ]]; then
  alias brewfile="cd $DOTFILES/configs/homebrew/ && brew bundle dump --force"
  alias brewupdate="brew bundle dump --force"
fi

# Git aliases
alias gbs="git branch | fzf-tmux -d 15"
alias gss="git status -s"
alias gst="git status"
alias gc="git commit"
alias gd="git diff"
