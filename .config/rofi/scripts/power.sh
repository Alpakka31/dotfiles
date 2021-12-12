#!/usr/bin/env bash
# Based on: https://github.com/adi1090x/rofi/blob/master/1080p/applets/menu/powermenu.sh

# Text
shutdown="Shutdown"
reboot="Reboot"
lock="Lock"
logout="Logout"

# Variables
if command -v xprop &> /dev/null; then
	if [ -n "$DISPLAY" ]; then
		XID=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
		XID=$(echo "$XID" | awk '{print $NF}')
		WMNAME=$(xprop -id $XID -notype -len 25 -f _NET_WM_NAME 8t | grep "_NET_WM_NAME" | grep -o '"[^"]\+"' | tr -d '"')
	else
		echo "DISPLAY not found"
		exit 1
	fi
else
	echo "xprop not found"
	exit 1
fi

theme="$HOME/.config/rofi/themes/power.rasi"
options=$(printf '%s|%s|%s|%s\n' "$shutdown" "$reboot" "$lock" "$logout" | rofi  -dmenu -sep '|' -selected-row 2 -theme $theme)

# Functions
handle_operation() {
	if [ "$1" == "shutdown" ] || [ "$1" == "reboot" ] || [ "$1" == "logout" ]; then
		prompt_options=$(printf '%s|%s' "Yes" "No" | rofi -dmenu -sep '|' -selected-row 2 -theme $theme)
		answer=""
		case "$prompt_options" in
			"Yes") answer="yes" ;;
			"No") answer="no" ;;
		esac

		if [ "$answer" == "yes" ]; then
			[ "$1" == "shutdown" ] && systemctl poweroff
			[ "$1" == "reboot" ] && systemctl reboot
			[ "$1" == "logout" ] && {
				if [ "$WMNAME" == "bspwm" ]; then
					bspc quit
				elif [ "$WMNAME" == "awesome" ]; then
					echo 'awesome.quit()' | awesome-client
				fi
			}
		elif [ "$answer" == "no" ]; then
			exit 0
		fi
	fi

	[ "$1" == "lock" ] && [ -x /usr/bin/betterlockscreen ] && {
		betterlockscreen -l
	}
}

case "$options" in
	"$shutdown") handle_operation "shutdown" ;;
	"$reboot") handle_operation "reboot" ;;
	"$lock") handle_operation "lock" ;;
	"$logout") handle_operation "logout" ;;
esac
