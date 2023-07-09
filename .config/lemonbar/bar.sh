#!/usr/local/bin/bash

res="${1}"
fifo="/tmp/panel_fifo"
[ -e "$fifo" ] && rm "$fifo"
mkfifo "$fifo"

date_time() {
	time=$(date +%-H:%M)
	date=$(date +%a\ %-d\.%-m\.%Y)
	echo "Clock $date $time"
}

volume() {
	level=$(mixer vol | awk '{print $NF}' | awk -F':' '{print $1}')
	echo "Volume $level"
}

wifi() {
    ipaddress=$(ifconfig wlan0 | awk '/inet/{print $2}')
    ssid=$(ifconfig wlan0 | awk '/ssid/{print $2}')

    echo "WiFi $ssid <-> $ipaddress"
}

memory() {
    # From neofetch
    mem_total="$(($(sysctl -n hw.physmem) / 1024 / 1024))"
    hw_pagesize="$(sysctl -n hw.pagesize)"
    mem_inactive="$(($(sysctl -n vm.stats.vm.v_inactive_count) * hw_pagesize))"
    mem_unused="$(($(sysctl -n vm.stats.vm.v_free_count) * hw_pagesize))"
    mem_cache="$(($(sysctl -n vm.stats.vm.v_cache_count) * hw_pagesize))"
    mem_free="$(((mem_inactive + mem_unused + mem_cache) / 1024 / 1024))"
    mem_used="$((mem_total - mem_free))"

    echo "Memory ${mem_used}MiB / ${mem_total}MiB"
}

cpu() {
    cpu_usage="$(printf "%b" "import psutil\nprint('{}%'.format(psutil.cpu_percent(interval=1)))" | python3)"
    echo "CPU ${cpu_usage}"
}

while :; do date_time; sleep 60; done > "$fifo" &
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
    echo "%{l}%{F#ff92df}${clock} %{F#FFFFFF}| cpu:%{F#ff92df}${cpu} %{F#FFFFFF}| mem:%{F#ff92df}${mem} %{F#FFFFFF}| vol:%{F#ff92df}${vol}% %{F#FFFFFF}| wifi:%{F#ff92df}${wifi} %{F#FFFFFF}"
done < "$fifo" | lemonbar -o 0 -f "Hack:style=Bold:pixelsize=14" -d -B "#CF000000" -g "${res}" | bash

