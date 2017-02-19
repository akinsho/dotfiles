#!/bin/zsh
# VIM_PROMPT="%{$fg_bold[green]%}[% NORMAL]%"
VIM_PROMPT=${VIM_PROMPT:-"[NORMAL]"}
# VI_MODE_INSERT="%{$fg_bold[yellow]%}[% INSERT]%"
VI_MODE_INSERT=${VI_MODE_INSERT:-"[INSERT]"}
# RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"


geometry_prompt_vim_mode_setup() {}

geometry_prompt_vim_mode_check(){
 # if bindkey | grep "vi-quoted-insert" > /dev/null 2>&1; then
 #   echo -n $VIM_PROMPT
 # else
 #   return 1
 # fi
  }
geometry_prompt_vim_mode_render(){
 if bindkey | grep "vi-quoted-insert" > /dev/null 2>&1; then
   echo -n "%{$fg_bold[yellow]%}"


  MODE_INDICATOR=$VI_MODE_INSERT


  case ${KEYMAP} in
    main|viins)
      MODE_INDICATOR=$VI_MODE_INSERT
      ;;
    vicmd)
      MODE_INDICATOR=$VIM_PROMPT
      ;;
  esac

  echo -n $MODE_INDICATOR
  echo -n "%{$reset_color%}"
fi
}



# geometry_prompt_vim_mode_render(){
#   function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
#     zle reset-prompt; zle -R
# }
# zle -N zle-line-init
# zle -N zle-keymap-select
# }

geometry_plugin_register vim_mode
