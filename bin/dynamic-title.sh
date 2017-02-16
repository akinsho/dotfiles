#!/bin.sh
# Shows a dynamic terminal title based on current directory or application
# using precmd and prexec hooks
# autoload -Uz add-zsh-hook
#
# function xterm_title_precmd(){
#   print -Pn '\e]2;%n@%m %1~\a'
# }
#
# function xterm_title_preexec(){
#   print -Pn '\e]2;%n@%m %1~ %#'
#   print -n "${(q)1}\a"
#
# }
#
# if [[ "$TERM" == (screen*|xterm*|rxvt*) ]]; then
#   add-zsh-hook -Uz precmd xterm_title_precmd
#   add-zsh-hook -Uz preexec xterm_title_preexec
# fi
