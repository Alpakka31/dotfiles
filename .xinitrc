# Start DBUS user session through a script instead of dbus-launch which is prone to hanging the X11 session
if [ -x /etc/X11/xinit/xinitrc.d/50-systemd-user.sh ]; then
	. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
fi
xrandr --output DP-0 --mode 2560x1440 --rate 144.00 --primary --left-of DP-2
xrandr --output DP-2 --mode 1920x1080 --rate 144.00 --right-of DP-0
#exec bspwm
exec awesome
