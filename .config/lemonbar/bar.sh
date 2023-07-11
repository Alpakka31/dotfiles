#!/usr/local/bin/bash

res="${1}"
fifo="/tmp/panel_fifo"
[ -e "$fifo" ] && rm "$fifo"
mkfifo "$fifo"

date_time() {
	time=$(date +%H:%M)
	date=$(date +%a\ %d\.%m\.%Y)
	echo "Clock $date $time"
}

volume() {
	level=$(sndioctl output.level | awk -F'=' '{print $NF}')
	echo "Volume $level"
}

wifi() {
    ipaddress=$(ifconfig iwx0 | awk '/inet/{print $2}')
    ssid=$(ifconfig iwx0 | awk '/nwid/{print $3}' | tr -d '"')

    echo "WiFi $ssid <-> $ipaddress"
}

memory() {
    # From neofetch
    mem_total="$(($(sysctl -n hw.physmem) / 1024 / 1024))"
    #mem_free="$(($(vmstat | awk 'END {printf $5}') / 1024))"
    mem_used="$(vmstat | awk 'END {printf $3}')"
    mem_used="${mem_used/M}"

    echo "Memory ${mem_used}MiB / ${mem_total}MiB"
}

cpu() {
    cpu_usage="$(printf "%b" "import psutil\nprint('{}%'.format(psutil.cpu_percent(interval=1)))" | python3)"
    echo "CPU ${cpu_usage}"
}

while :; do date_time; sleep 3; done > "$fifo" &
while :; do volume; sleep 3; done > "$fifo" &
while :; do wifi; sleep 60; done > "$fifo" &
while :; do memory; sleep 3; done > "$fifo" &
while :; do cpu; sleep 3; done > "$fifo" &

while read -r line; do
	case $line in
        Clock*)
            clock="${line:5}"
            ;;
        Volume*)
            vol="${line:6}"
            ;;
        WiFi*)
            wifi="${line:4}"
            ;;
        Memory*)
            mem="${line:6}"
            ;;
        CPU*)
            cpu="${line:3}"
            ;;
	esac
    #echo "%{l}%{F#ff92df}${clock} %{F#FFFFFF}| cpu:%{F#ff92df}${cpu} %{F#FFFFFF}| mem:%{F#ff92df}${mem} %{F#FFFFFF}| vol:%{F#ff92df}${vol}% %{F#FFFFFF}| wifi:%{F#ff92df}${wifi} %{F#FFFFFF}"

    echo "%{l}%{F#ff92df}${clock} %{F#FFFFFF}| cpu:%{F#ff92df}${cpu} %{F#FFFFFF}| mem:%{F#ff92df}${mem} %{F#FFFFFF}| vol:%{F#ff92df}${vol}% %{F#FFFFFF}"
done < "$fifo" | lemonbar-xft -o 0 -f "Hack:style=Bold:pixelsize=14" -d -B "#CF000000" -g "${res}" | bash

