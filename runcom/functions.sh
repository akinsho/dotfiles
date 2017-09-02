# A Handful of very useful functions courtesy of
# https://github.com/jdsimcoe/dotfiles/blob/master/.zshrc

tr(){
  #Defaults to 3 levels deep
  "tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 20 -L ${1:-3} -aC $2"
}
# Jumps
 j() {
   jump '$@'
 }

# Vim
v() {
  nvim "$@"
}

# Teamocil
t() {
  teamocil "$@"
}

# chmod a directory
ch() {
  sudo chmod -R 777 "$@"
}

# chown a directory
cho() {
  sudo chown -R www:www "$@"
}

# Do a Git clone
gcl() {
  git clone "$@"
}

# Do a Git commit
gc() {
  git add .;git add -u :/;git commit -m "$@";
}

# Do a Git push from the current branch
gp() {
  git push origin "$@"
}

# Do a Git push setting the upstream from your current branch
gpuo() {
  git push --set-upstream origin "$@"
}

# Do a Git commit/push
gcap() {
  git add .;git add -u :/;git commit -m "$@";git push
}

# Do a Git rebase
gpr() {
  git pull --rebase "$@"
}

# Do a Git commit/push and a heroku deploy
gcph() {
  git add .;git add -u :/;git commit -m "$@";git push;git push heroku master
}

# Do a Heroku commit/push/deploy
gph() {
  git add .;git add -u :/;git commit -m "$@";git push heroku master
}

# Install a Gulp plugin and save to devDependencies
gi() {
  npm install --save-dev gulp-"$@"
}

# Install a generic NPM module and save to devDependencies
npmi() {
  npm install --save-dev "$@"
}

# _cdls_chpwd_handler () {
#   emulate -L zsh
#   ls -A
# }

# autoload -U add-zsh-hook
# add-zsh-hook chpwd _cdls_chpwd_handler
