# Start DBUS user session through a script instead of dbus-launch which is prone to hanging the X11 session
if [ -x /etc/X11/xinit/xinitrc.d/50-systemd-user.sh ]; then
	. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
fi
exec bspwm
