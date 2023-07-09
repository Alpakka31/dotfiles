#!/bin/sh

export XDG_RUNTIME_DIR=/tmp/user/$(id -u)

xrandr --output DisplayPort-2 --mode 2560x1440 --rate 144.00 --primary --right-of DisplayPort-0
xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144.00 --left-of DisplayPort-2
setxkbmap fi &
xsetroot -cursor_name left_ptr &

feh --bg-scale $HOME/Kuvat/sky.jpg &
picom --backend glx --config $HOME/.config/picom/picom.conf &
/usr/local/bin/musicpd ~/.mpd/musicpd.conf

$HOME/.config/lemonbar/bar.sh "2560x20+1920+0" &
$HOME/.config/lemonbar/bar_mon2.sh "1920x20+0+0" &
exec /usr/local/bin/cwm
