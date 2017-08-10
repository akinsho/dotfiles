#!/bin/sh

LSEP=
LSEPE=
RSEP=
RSEPE=

CLOCK=⌚CALENDAR=☼
MUSIC=♫

WIDTH=${1}

SMALL=80
MEDIUM=140

if [ "$WIDTH" -gt "$MEDIUM" ]; then
  MPD="#[fg=colour252,bg=default,nobold,noitalics,nounderscore]$RSEP#[fg=colour16,bg=colour252,bold,noitalics,nounderscore] $MUSIC $(mpc current)"
  date_colour='colour252'
fi

if [ "$WIDTH" -ge "$SMALL" ]; then
  UNAME="#[fg=colour252,bg=colour236,nobold,noitalics,nounderscore]$RSEP#[fg=colour16,bg=colour252,bold,noitalics,nounderscore] $(uname -n)"
fi
DATE="#[fg=colour236,bg=${date_colour:-default},nobold,noitalics,nounderscore]$RSEP#[fg=colour247,bg=colour236,nobold,noitalics,nounderscore] $CALENDAR $(date +'%D')"
TIME="#[fg=colour241,bg=colour236,nobold,noitalics,nounderscore]$RSEPE#[fg=colour252,bg=colour236,bold,noitalics,nounderscore] $CLOCK $(date +'%H:%M')"

echo "$MPD $DATE $TIME $UNAME " | sed 's/ *$/ /g'
