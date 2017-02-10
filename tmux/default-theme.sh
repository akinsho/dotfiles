####################################
# Tmux Bar Styling                 #
####################################
# panes
set -g pane-border-fg black
set -g pane-active-border-fg brightred

## Status bar design
# status line
# set -g status-utf8 on
set -g status-justify left
set -g status-bg default
set -g status-fg colour12
set -g status-interval 2

# messaging
set -g message-fg black
set -g message-bg yellow
set -g message-command-fg blue
set -g message-command-bg black

#window mode
setw -g mode-bg colour6
setw -g mode-fg colour0

# window status
setw -g window-status-format " #F#I:#W#F "
setw -g window-status-current-format " #F#I:#W#F "
setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "
setw -g window-status-current-bg colour0
setw -g window-status-current-fg colour11
setw -g window-status-current-attr dim
setw -g window-status-bg green
setw -g window-status-fg black
setw -g window-status-attr reverse

# Info on left (I don't have a session display for now)
set -g status-left ''

# loud or quiet?
set-option -g visual-activity on
set-option -g visual-bell off
set-option -g visual-silence off
set-window-option -g monitor-activity off
set-option -g bell-action none

set -g default-terminal "screen-256color"

# The modes {
setw -g clock-mode-colour colour135
setw -g mode-attr bold
setw -g mode-fg colour196
setw -g mode-bg colour238

# }
# The panes {

set -g pane-border-bg colour235
set -g pane-border-fg colour238
set -g pane-active-border-bg colour236
set -g pane-active-border-fg colour51

# }
# The statusbar {
# Styling variables
tm_icon=' 🙈 '
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


# Segments for bar
# separator FG colours the ARROW, variable BACKGROUND colors the BLOCK
tm_tunes="#[bg=colour234,fg=colour178]$tm_right_separator_black#[fg=black,bg=colour178]#(osascript ~/.dotfiles/applescripts/tunes.scpt)"

tm_spotify="#[fg=$tm_color_background,bg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/spotify.scpt)"

tm_itunes="#[fg=$tm_color_music,bg=$tm_color_background]$tm_right_separator_black#[fg=$tm_color_background,bg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/itunes.scpt)"

tm_battery="#[fg=colour255,bg=$tm_color_music]$tm_right_separator_black#[bg=colour255]#(~/.dotfiles/bin/battery_indicator.sh)"
# separator fg colors the arrow(250), bg colors surrounding space(default), date fg
# colors text bg the block (250)
tm_date="#[bg=colour245,fg=colour250]$tm_right_separator_black#[bg=colour250,fg=black,bold]%R %d %b "
# Host bg = colour245, seperator fg = colour245 (need to match)
tm_host="#[bg=colour241,fg=colour245]$tm_right_separator_black#[bg=colour245,fg=colour226,bold] 🖥  #h "
# tm_host="  #h "
tm_session_name="#[bg=colour172,fg=$tm_color_background,bold]$tm_icon #S #[fg=$tm_color_feature,bg=default,nobold]"
tm_continuum="#[bg=colour178,fg=colour241]$tm_right_separator_black#[fg=colour233,bg=colour241,bold] Continuum: #{continuum_status} " 


set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour137
set -g status-attr dim
set -g status-left $tm_session_name
set -g status-right "$tm_tunes $tm_continuum $tm_host  $tm_date"
# Original Status line if in need to revert
# set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
set -g status-left-length 100
# set -g status-right-length 50
set -g status-left-length 20

setw -g window-status-current-fg colour81
setw -g window-status-current-bg colour238
setw -g window-status-current-attr bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '

setw -g window-status-fg colour138
setw -g window-status-bg colour235
setw -g window-status-attr none
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

setw -g window-status-bell-attr bold
setw -g window-status-bell-fg colour255
setw -g window-status-bell-bg colour1

# }
# The messages {

set -g message-attr bold
set -g message-fg colour232
set -g message-bg colour166

# }

