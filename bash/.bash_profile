export PATH="/Users/A_nonymous/.rbenv/shims:${PATH}"
export RBENV_SHELL=bash
source '/usr/local/Cellar/rbenv/1.0.0/libexec/../completions/rbenv.bash'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}
# Enable tab completion
source ~/git-completion.bash

# colors!
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
white='\[\e[1;37m\]'
light_blue="\[\e[1;34m\]"
light_red='\[\e[1;31m\]'
light_cyan="\[\e[1;36m\]"
purple="\[\033[0;35m\]"
GRAY="\[\033[1;30m\]"
CYAN="\[\033[0;36m\]"
reset="\[\033[0m\]"

#Powerline prompts
if [ -d "$HOME/Library/Python/2.7/bin" ]; then
    PATH="$HOME/Library/Python/2.7/bin:$PATH"
fi
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
LANG="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
#My environment variables
coding=~/desktop/coding
desktop=~/desktop
powerline_path=/Users/A_nonymous/Library/Python/2.7/lib/python/site-packages
# Git Aliases
alias gs="git status";
alias gc="git checkout";
alias gb="git branch";
alias ga="git add"
alias gp="git push"
#Open config files in vim

alias bashp="nvim ~/.bash_profile"
alias vimrc="nvim ~/.vimrc"
alias nvimrc="nvim ~/.config/nvim/init.vim"
PS1="💩  "
#General aliases
alias la="ls -a"
alias lla="ls -la"
alias back="cd $OLDPWD"

export EDITOR=neovim
export BROWSER=google-chrome
#Allows cd command to take an argument of number of cds to go up
# up(){
#   local d=""
#     limit=$1
#       for ((i=1 ; i <= limit ; i++))
#           do
# 	        d=$d/..
# 	    done
#       d=$(echo $d | sed 's/^\///')
#         if [ -z "$d" ]; then
# 	    d=..
#       fi
#         cd $d
# }
#


