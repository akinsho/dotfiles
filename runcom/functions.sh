#!/bin/zsh
# courtesy of wes bos https://gist.github.com/wesbos/1432b08749e3cd2aea22fcea2628e2ed
function _t() {
  # Defaults to 3 levels deep, do more with `t 5` or `t 1`
  # pass additional args after
  local levels=${1:-3}; shift
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst -L $levels -aC $@
}

# A Handful of very useful functions courtesy of
# https://github.com/jdsimcoe/dotfiles/blob/master/.zshrc

function port() {
  lsof -n -i ":$@" | grep LISTEN
}

function colours() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}m colour${i}"
    if (( $i % 5 == 0 )); then
      printf "\n"
    else
      printf "\t"
    fi
  done
}

# Vim
function v() {
  nvim "$@"
}

# Teamocil
function t() {
  teamocil "$@"
}

# chmod a directory
function ch() {
  sudo chmod -R 777 "$@"
}

# chown a directory
function cho() {
  sudo chown -R www:www "$@"
}

# Do a Git clone
function clone() {
  git clone "$@"
}

# Do a Git commit
function quickie() {
  git add .;git add -u :/;git commit -m "$@";
}

quickpush() {
  git add .
  git commit -m "$@"
  echo "🍏 commit message: [$@]"
  git push
  echo 🚀  quick push success... or not.
}

# Do a Git push from the current branch
function push() {
  git push origin "$@"
}

# Do a Git push setting the upstream from your current branch
function gpuo() {
  git push --set-upstream origin "$@"
}

# Do a Git commit/push
function gcap() {
  git add .;git add -u :/;git commit -m "$@";git push
}

# Do a Git rebase
function gpr() {
  git pull --rebase "$@"
}

# Do a Git commit/push and a heroku deploy
function gcph() {
  git add .;git add -u :/;git commit -m "$@";git push;git push heroku master
}

# Do a Heroku commit/push/deploy
function gph() {
  git add .;git add -u :/;git commit -m "$@";git push heroku master
}

# Install a generic NPM module and save to devDependencies
function npmi() {
  npm install --save-dev "$@"
}

_cdls_chpwd_handler () {
  emulate -L zsh
  ls -A
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _cdls_chpwd_handler
