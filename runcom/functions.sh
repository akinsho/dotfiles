#!/bin/zsh
# A Handful of very useful functions courtesy of
# https://github.com/jdsimcoe/dotfiles/blob/master/.zshrc

function tr(){
  #Defaults to 3 levels deep
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 20 -L ${1:-3} -aC $2
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
