#! /bin/bash

set -e

exec "$@" & # start game
sleep 1 # wait a bit for game window

# find window with size greater than 99x99 that is not a steam window
RESULT=$(xwininfo -display $DISPLAY -root -tree | grep "^     0x" | grep -E "[0-9]{3}x[0-9]{3}" \
    | grep -v \"steam\" \
    | grep -v \"Steam\"\: \
    | grep -v \"SteamOverlay\"\: \
    | grep -v \"steamwebhelper\"\: \
    | grep -v \"Steam\ Big\ Picture\ Mode\"\: \
    | grep -v \"mangoapp\ overlay\ window\"\: \
)

WIN_ID=`echo $RESULT | cut -d' ' -f 1`

ORIGINAL=`xprop -display :0 -root | grep GAMESCOPECTRL_BASELAYER_APPID | cut -d'=' -f 2`

# apply STEAM_GAME property to game window so steamos compositor shows game in foreground
xprop -display $DISPLAY -id $WIN_ID -f STEAM_GAME 32c -set STEAM_GAME 1

# add fake steam id to GAMESCOPECTRL_BASELAYER_APPID root window property so gamescope focuses the window
xprop -display $DISPLAY -root -format GAMESCOPECTRL_BASELAYER_APPID 32co -set GAMESCOPECTRL_BASELAYER_APPID "1,$ORIGINAL"

wait # wait for game exit

# revert the gamescope property change
xprop -display $DISPLAY -root -format GAMESCOPECTRL_BASELAYER_APPID 32co -set GAMESCOPECTRL_BASELAYER_APPID "$ORIGINAL"