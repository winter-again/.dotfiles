#!/usr/bin/env bash

# source: https://github.com/adi1090x/rofi/blob/master/files/powermenu/type-1/powermenu.sh
theme="$HOME/.config/rofi/power-menu-config.rasi"
host=`hostname`

shutdown=' Shutdown'
reboot=' Reboot'
suspend='󰒲 Suspend'
lock='󰌾 Lock'
logout='󰍃 Logout'
yes='Yes'
no='No'

rofi_cmd() {
    rofi -dmenu \
        -p "$host:" \
        -theme ${theme}
}

confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 500px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you sure?' \
		-theme ${theme}
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			# mpc -q pause
			# amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
            i3-msg exit
		fi
	else
		exit 0
	fi
}

chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		betterlockscreen --lock dim 5
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac

# old
# chosen=$(printf " Power off\n Restart\n󰒲 Suspend\n󰍃 Logout\n󰌾 Lock" | rofi -dmenu -p "Power:" -dpi 1 -theme ${theme})
#
# case "$chosen" in
#     " Power off") systemctl poweroff ;;
#     " Restart") systemctl reboot ;;
#     "󰒲 Suspend") systemctl suspend ;;
#     "󰍃 Logout") i3-msg exit ;;
#     "󰌾 Lock") betterlockscreen --lock dim 5 ;;
#     *) exit 1 ;;
# esac
