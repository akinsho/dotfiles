# A Handful of very useful functions courtesy of
# https://github.com/jdsimcoe/dotfiles/blob/master/.zshrc

# Jumps
# function j() {
#   jump "$@"
# }

# Vim
function v() {
  vim "$@"
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
function gcl() {
  git clone "$@"
}

# Do a Git commit
function gc() {
  git add .;git add -u :/;git commit -m "$@";
}

# Do a Git push from the current branch
function gp() {
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

# Do a Git commit/push/deploy - no deploy script yet
# function gcpd() {
#   git add .;git add -u :/;git commit -m "$@";git push;sh utilities/deploy.sh
# }

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

# Install a Gulp plugin and save to devDependencies
function gi() {
  npm install --save-dev gulp-"$@"
}

# Install a generic NPM module and save to devDependencies
function npmi() {
  npm install --save-dev "$@"
}

# _cdls_chpwd_handler () {
#   emulate -L zsh
#   ls -A
# }

# autoload -U add-zsh-hook
# add-zsh-hook chpwd _cdls_chpwd_handler
# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  vim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}
