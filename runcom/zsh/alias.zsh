# ================================================================================
# Aliases
# ================================================================================
alias cl='clear'
alias sant='source $HOME/.dotfiles/zsh-antigen/antigen/antigen.zsh'
alias b='source ~/Dotfiles/bin/fzf-chrome.rb'
alias rn='ranger'
alias sho='ls -aC'
alias restart='exec zsh'
alias src='. ~/.zshrc'
alias gphm='git push heroku master'
alias ea='vim ~/Dotfiles/runcom/zsh/alias.zsh'
alias eant='vim $DOTFILES/zsh-antigen/.antigenrc'
alias ez="vim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias et="vim ~/.tmux.conf"


# alias ohmyzsh="vim ~/.oh-my-zsh"
alias sesh="vim -S"
# alias v="vim"
alias tmux="tmux -2"
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

# alias tmux="TERM=screen-256color tmux"
# alias tmux="tmux -CC"
# alias attach="tmux -CC attach"
alias browse="browser-sync start --server"
alias ctags="`brew --prefix`/bin/ctags"
#Git aliases
alias serve='python -m SimpleHTTPServer'
