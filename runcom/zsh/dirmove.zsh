# File manager like key bindings 
cdUndoKey(){
popd > /dev/null
zle reset-prompt
echo
ls
echo
}

cdParentKey(){
  pushd .. > /dev/null
  zle reset-prompt
  echo
  ls
  echo
}

zle -N    cdParentKey
zle -N    cdUndoKey


# Tab + k will move back to the parent directory
bindkey '^Ik'    cdParentKey
# Tab + h will undo the previous move but show the dir that was just moved into
bindkey '^Ih'    cdUndoKey
