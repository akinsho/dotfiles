# Aliases

alias ea='vim ~/.oh-my-zsh/lib/alias.zsh'
alias ez="vim ~/.zshrc"
alias ev="vim ~/.vimrc"
alias et="vim ~/.tmux.conf"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias session="vim -S"
alias v="vim"
alias tmux="tmux -2"
alias ta="tmux attach -t"
alias tnew="tmux new -s"
alias tls="tmux ls"
alias tkill="tmux kill-session -t"

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'
# Silence or turn up the volume
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
# Open google chrome from terminal
alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"



# alias tmux="TERM=screen-256color tmux"
# alias tmux="tmux -CC"
# alias attach="tmux -CC attach"
alias browse="browser-sync start --server"
alias ctags="`brew --prefix`/bin/ctags"
#Git aliases
alias git='g'
alias serve='python -m SimpleHTTPServer'
