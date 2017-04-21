# ================================================================================
# Aliases
# ================================================================================
# alias v='f -t -e vim -b viminfo' # quick opening files with vim
alias la='ls -aG'
alias nv='nvim'
alias cl='clear'
alias c='fasd_cd -d'
alias o='a -e xdg-open' # quick opening files with xdg-open
alias b='source ~/Dotfiles/bin/fzf-chrome.rb'
alias rn='ranger'
alias gbs="git branch | fzf-tmux -d 15"
alias restart='exec zsh'
alias src='. ~/.zshrc'
alias gphm='git push heroku master'
alias ea='vim ~/Dotfiles/runcom/zsh/alias.zsh'
alias ez="vim ~/.zshrc"
alias nez="nvim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias nev="nvim ~/.vimrc"
alias et="vim ~/.tmux.conf"
alias net="nvim ~/.tmux.conf"


# alias ohmyzsh="vim ~/.oh-my-zsh"
alias lip="lsof -Pn -i4"
alias ports=" _ lsof -i -P | grep -i 'listen'"
alias sesh="vim -S"
alias vi="vim"
alias tmux="tmux -2"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tkill="tmux kill-session -t"

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'
# Silence or turn up the volume
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
# Open google chrome from terminal
alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"

alias -s js=vim
alias -s html=vim
alias -s css=vim
alias -s py=vim

# alias tmux="tmux -CC"
# alias attach="tmux -CC attach"
alias browse="browser-sync start --server"
alias ctags="`brew --prefix`/bin/ctags"
#Git aliases
alias serve='python -m SimpleHTTPServer'
