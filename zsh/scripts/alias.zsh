#------------------------------------------------------------------------------
# ALIASES
#------------------------------------------------------------------------------
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias ls="ls --color=auto --hyperlink=auto $@"
if [[ $+commands[exa] ]]; then
  alias l="exa --long --all --git --color=always --group-directories-first --icons $@"
  alias lt="exa --icons --all --color=always -T $@"
else
  alias l='ls -lFh'     # size,show type,human readable
fi
alias dv='DEVELOPING=1 nvim'
alias lvim="VIMRUNTIME=runtime $PROJECTS_DIR/contributing/neovim/build/bin/nvim"
# Quick access to the .zshrc file
alias ez="${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc"
alias et="${=EDITOR} ${ZDOTDIR:-$HOME}/.tmux.conf"
alias grep='grep --color'
alias x="exit"
alias del="rm -rf"
alias md="mkdir -p"
alias dots="cd $DOTFILES"
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias minimalvim="nvim -u ~/minimal.vim"
alias notes="cd $SYNC_DIR/neorg/ && nvim"
# This allow using neovim remote when nvim is called from inside a running vim instance
[ -n "$NVIM_LISTEN_ADDRESS" ] && alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
alias cl='clear'
alias src="exec $SHELL"
alias dnd='do-not-disturb toggle'
(( $+commands[npm] )) && alias ns="clear && npm start"
(( $+commands[npm] )) && alias nt="clear && npm test"
(( $+commands[yarn] )) && alias yt="clear && yarn test"
(( $+commands[yarn] )) && alias ys="clear && yarn start"
(( $+commands[bat] )) && alias cat='bat'
#------------------------------------------------------------------------------
# TMUX
#------------------------------------------------------------------------------
alias ta="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tkss="killall tmux"
alias tkill="tmux kill-session -t"
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
# suffix aliases set the program type to use to open a particular file with an extension
alias -s js=nvim
alias -s html=nvim
alias -s css=nvim
alias fuckit='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'

if which kitty >/dev/null; then
  alias icat="kitty +kitten icat"
fi

if [[ `uname` == 'Linux' ]]; then
  alias o='a -e xdg-open' # quick opening files with xdg-open
  alias open='xdg-open'
elif [[ `uname` == 'Darwin' ]]; then
  alias brewfile="brew bundle dump --global --force"
fi

# Check if main exists and use instead of master
function git_main_branch() {
  local branch
  for branch in main trunk; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo master
}

# -------------------------------------------------------------------------------
# Git aliases
# -------------------------------------------------------------------------------
# source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh#L53
# NOTE: a lot of these commands are single quoted ON PURPOSE to prevent them
# from being evaluated immediately rather than in the shell when the alias is
# expanded
alias g="git"
alias glog="git log"
alias gss="git status -s"
alias gst="git status"
alias gc="git commit"
alias gd="git diff"
alias gco="git checkout"
alias ga='git add'
alias gaa='git add --all'
alias gcb='git checkout -b'
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
alias gmom='git merge origin/$(git_main_branch)'
alias gp='git push'
alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gpristine='git reset --hard && git clean -dffx'
alias gcl='git clone --recurse-submodules'
alias gl='git pull'
alias glum='git pull upstream $(git_main_branch)'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias gcm='git checkout $(git_main_branch)'
alias gcd="git checkout development"
alias gcb="git checkout -b"
alias gstp="git stash pop"
alias gsts="git stash show -p"

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}


function gdnolock() {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}
compdef _git gdnolock=git-diff
