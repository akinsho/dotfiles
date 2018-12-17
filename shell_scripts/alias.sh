# =============================================================================
# Aliases
# =============================================================================
alias l="colorls -r"
alias top="vtop"
alias x="exit" # Exit Terminal
alias t=_t
alias del="rm -rf"
alias eal="vim ~/Dotfiles/configs/alacritty/alacritty.yml"
alias neal="nvim ~/Dotfiles/configs/alacritty/alacritty.yml"
alias dots="cd ~/Dotfiles"
alias coding="cd ~/Desktop/Coding"
alias magit="nvim -c \"MagitOnly\""
alias brewfile="cd ~/Dotfiles/configs/homebrew/ && brew bundle dump --force"
alias lp="lsp"
alias la='ls -aG'
alias fixcl='git commit --am "update changelog" && git push'
alias v='nvim'
alias brewupdate="brew bundle dump --force"
alias vi='vim'
alias nv='nvim'
alias cl='clear'
alias o='a -e xdg-open' # quick opening files with xdg-open
alias b="source \${DOTFILES}/bin/fzf-chrome.rb"
alias rn='ranger'
alias gbs="git branch | fzf-tmux -d 15"
alias restart='exec zsh'
alias src='. ~/.zshrc'
alias gphm='git push heroku master'
alias ea="nvim \${DOTFILES}/runcom/zsh/alias.sh"
alias dnd='do-not-disturb toggle'
alias ez="nvim ~/.zshrc"
alias nez="nvim ~/.zshrc"
alias ev="nvim ~/.vimrc"
alias et="nvim ~/.tmux.conf"
alias nd="clear && npm run develop"
alias ns="clear && npm start"
alias nt="clear && npm test"
alias yt="clear && yarn test"
alias ys="clear && yarn start"
alias yd="cl && yarn develop"
alias ydl="cl && yarn develop:local"

#alias ctags if you used homebrew
alias ctags="\$(brew --prefix)/bin/ctags"
alias sesh="vim -S"
alias tmux="tmux"
# alias tmux="tmux -2 -u"
alias imux="tmux -CC"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tkss="killall tmux"
alias tkill="tmux kill-session -t"
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
# Silence or turn up the volume
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
# Open google chrome from terminal
alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"

alias -s js=nvim
alias -s html=nvim
alias -s css=nvim

alias ta="tmux -CC attach"
#Git aliases
alias browse="browser-sync start --server"
alias serve='python -m SimpleHTTPServer'
alias fuckit='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'
