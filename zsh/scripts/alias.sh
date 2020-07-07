# =============================================================================
# Aliases
# =============================================================================
alias l='ls -lFh'     #size,show type,human readable
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file
alias grep='grep --color'
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
  alias brewfile="cd $DOTFILES/.config/homebrew/ && brew bundle dump --force"
  alias brewupdate="brew bundle dump --force"
fi

# Check if main exists and use instead of master
function git_main_branch() {
  if [[ -n "$(git branch --list main)" ]]; then
    echo main
  else
    echo master
  fi
}

# Git aliases
# source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh#L53
alias g="git"
alias gss="git status -s"
alias gst="git status"
alias gc="git commit"
alias gd="git diff"
alias gco="git checkout"
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gbr='git branch --remote'
alias gc='git commit -v'
alias gd='git diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gm='git merge'
alias gma='git merge --abort'
alias gmom="git merge origin/$(git_main_branch)"
alias gp='git push'
alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gcl='git clone --recurse-submodules'
alias gl='git pull'
alias gcm="git checkout $(git_main_branch)"
alias gstp="git stash pop"
alias gsts="git stash show -p"
