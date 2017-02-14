#!/bin/sh
# Load mtime at shell start-up
echo "zshrc mtime:$(stat -f"%m" ~/.zshrc)" >&2
export ZSHRC_MTIME=$(stat -f"%m" ~/.zshrc)

PROMPT_COMMAND="check_and_reload_zshrc"
check_and_reload_zshrc()( {
echo "function is running"
if [[ "$(stat -f"%m" ~/.zshrc)"!=$ZSHRC_MTIME ]];then
  export ZSHRC_MTIME="$(stat -f"%m" ~/.zshrc)"
  echo "zshrc changed. re-sourcing...">&2
  . ~/.zshrc
fi

} )
# Has to be called manually push generates several errors
check_and_reload_zshrc
