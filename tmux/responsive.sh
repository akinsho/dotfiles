#!/bin/sh
# Segments for bar
# separator FG colours the ARROW, variable BACKGROUND colors the BLOCK
# The spelling of color MUST be COLOUR
tm_color_foreground=colour250
tm_color_background=colour241
tm_color_inactive=colour235
tm_color_feature=colour245
tm_color_music=colour238
tm_left_separator=''
tm_left_separator_black=''
tm_right_separator=''
tm_right_separator_black=''
tm_session_symbol=''
tm_color_feature=colour4

tm_spotify="#[fg=$tm_color_background,bg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/spotify.scpt)"

tm_itunes="#[fg=$tm_color_music,bg=$tm_color_background]$tm_right_separator_black#[fg=$tm_color_background,bg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/itunes.scpt)"

# Make status bar responsive
WIDTH=${1}
SMALL=80
MEDIUM=120

if [ "$WIDTH" -gt "$MEDIUM"]; then
tm_tunes="#[bg=colour234,fg=colour178]$tm_right_separator_black#[fg=black,bg=colour178]#(osascript ~/.dotfiles/applescripts/tunes.scpt)"

tm_battery="#[fg=colour255,bg=$tm_color_music]$tm_right_separator_black#[bg=colour255]#(~/.dotfiles/bin/battery_indicator.sh)"
# separator fg colors the arrow(250), bg colors surrounding space(default), date fg
# colors text bg the block (250)
# Host bg = colour245, seperator fg = colour245 (need to match)
tm_continuum="#[bg=colour178,fg=colour241]$tm_right_separator_black#[fg=colour233,bg=colour241,bold] Continuum: #{continuum_status} " 
fi

if ["$WIDTH" -ge "$SMALL"]; then
tm_host="#[bg=colour241,fg=colour245]$tm_right_separator_black#[bg=colour245,fg=colour226,bold]   #h "
# uname="#[bg=colour241,fg=colour245]$tm_right_separator_black#[fg=colour16,bg=colour252,bold,noitalics,nounderscore] $(uname -n)"
#$uname
fi
tm_date="#[bg=colour245,fg=colour250]$tm_right_separator_black#[bg=colour250,fg=black,bold]%R %d %b "


echo "$tm_tunes $tm_battery $tm_host $tm_continuum  $tm_date" | sed 's/ *$/ /g'
