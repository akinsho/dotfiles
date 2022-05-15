# A Handful of very useful functions courtesy of
# https://github.com/jdsimcoe/dotfiles/blob/master/.zshrc
function port() {
  lsof -n -i ":$@" | grep LISTEN
}

# Helper function to run a diff against a branch and exclude a file
function gdmin() {
  local branchname=${1:-develop}
  local ignore=${2:-package\-lock.json}
  git diff $branchname -- ":(exclude)"$ignore
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


function build-nvim() {
  neovim_dir="$PROJECTS_DIR/contributing/neovim"
  [ ! -d $neovim_dir ] && git clone git@github.com:neovim/neovim.git $neovim_dir
  pushd $neovim_dir
  git checkout master
  git pull upstream master
  [ -d "$neovim_dir/build/" ] && rm -r ./build/  # clear the CMake cache
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  popd
}

fancy-ctrl-z () {
if [[ $#BUFFER -eq 0 ]]; then
  BUFFER="fg"
  zle accept-line
else
  zle push-input
  zle clear-screen
fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
if [[ $BUFFER == sudo\ * ]]; then
  LBUFFER="${LBUFFER#sudo }"
elif [[ $BUFFER == $EDITOR\ * ]]; then
  LBUFFER="${LBUFFER#$EDITOR }"
  LBUFFER="sudoedit $LBUFFER"
elif [[ $BUFFER == sudoedit\ * ]]; then
  LBUFFER="${LBUFFER#sudoedit }"
  LBUFFER="$EDITOR $LBUFFER"
else
  LBUFFER="sudo $LBUFFER"
fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
