# =============================================================================
# Aliases
# =============================================================================
alias l="colorls -r"
alias top="vtop"
alias x="exit" # Exit Terminal
alias t=_t
alias del="rm -rf"
alias dots="cd $DOTFILES"
alias coding="cd ~/Desktop/Coding"
alias brewfile="cd $DOTFILES/configs/homebrew/ && brew bundle dump --force"
alias lp="lsp"
alias la='ls -aG'
alias v='nvim'
alias brewupdate="brew bundle dump --force"
alias vi='vim'
alias nv='nvim'
alias cl='clear'
alias o='a -e xdg-open' # quick opening files with xdg-open
alias gbs="git branch | fzf-tmux -d 15"
alias restart='exec zsh'
alias src='. ~/.zshrc'
alias dnd='do-not-disturb toggle'
alias ez="nvim ~/.zshrc"
alias ev="nvim ~/.vimrc"
alias et="nvim ~/.tmux.conf"
alias ns="clear && npm start"
alias nt="clear && npm test"
alias yt="clear && yarn test"
alias ys="clear && yarn start"

alias esy="nocorrect esy"
alias tmux="tmux"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tkss="killall tmux"
alias tkill="tmux kill-session -t"
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

alias -s js=nvim
alias -s html=nvim
alias -s css=nvim

alias ta="tmux -CC attach"
alias serve='python -m SimpleHTTPServer'
alias fuckit='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'
