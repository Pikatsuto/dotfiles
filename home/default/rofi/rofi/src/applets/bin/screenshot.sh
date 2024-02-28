#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: `xdg-user-dir PICTURES`/Screenshots"

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='5'
	win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
	list_col='1'
	list_row='5'
	win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
	list_col='1'
	list_row='5'
	win_width='520px'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
	list_col='5'
	list_row='1'
	win_width='670px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1="󰹑 Capture Desktop"
	option_2="󱫴 apture Area"
	option_3="󰖯 Capture Window"
	option_4="󱑂 Capture in 5s"
	option_5=" Screen to GIF"
else
	option_1="󰹑"
	option_2="󱫴"
	option_3="󰖯"
	option_4="󱑂"
	option_5=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -u low --replace=699'
	${notify_cmd_shot} "Copied to clipboard."
	viewnior ${dir}/"$file"
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

# Copy screenshot to clipboard
copy_shot () {
	tee "$file" | xclip -selection clipboard -t image/png
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow () {
	cd ${dir} && sleep 0.5 && maim -u -f png | copy_shot
	notify_view
}

shot5 () {
	countdown '5'
	sleep 1 && cd ${dir} && maim -u -f png | copy_shot
	notify_view
}

screen_to_gif () {
  mouse_info=$(xdotool getmouselocation --shell)
  mouse_y=$(grep "Y=" <<< ${mouse_info} | sed "s/Y=//g")
  mouse_x=$(grep "X=" <<< ${mouse_info} | sed "s/X=//g")

  peek_pos_y=0
  peek_pos_x=0
  peek_res_y=1080
  peek_res_x=1920

  screens_info=$(xrandr | grep " connected" | sed "s/ primary//" | cut -d " " -f 3)
  for screen_info in ${screens_info}; do
    screen_pos_y=$(cut -d "+" -f 3 <<< ${screen_info})
    screen_pos_x=$(cut -d "+" -f 2 <<< ${screen_info})

    screen_res=$(cut -d "+" -f 1 <<< ${screen_info})
    screen_res_y=$(cut -d "x" -f 2 <<< ${screen_res})
    screen_res_x=$(cut -d "x" -f 1 <<< ${screen_res})

    echo "
    ${screen_pos_y} \t ${screen_res_y}
    ${screen_pos_x} \t ${screen_res_x}

    ${mouse_y}
    ${mouse_x}

    "

    if ((
      ${mouse_y} >= ${screen_pos_y}
      && ${mouse_y} <= (${screen_res_y} + ${screen_pos_y})
      && ${mouse_x} >= ${screen_pos_x}
      && ${mouse_x} <= (${screen_res_x} + ${screen_pos_x})
    )); then
      peek_pos_y=${screen_pos_y}
      peek_pos_x=${screen_pos_x}
      peek_res_y=${screen_res_y}
      peek_res_x=${screen_res_x}

      echo "ok"
    fi
  done

	pkill -f peek
  screen -d -m peek --no-headerbar
  sleep 1
  peekInstance=$(echo $(xdotool search --name peek) | cut -d " " -f 2)
  xdotool windowmove $peekInstance ${peek_pos_x} ${peek_pos_y}
  xdotool windowsize $peekInstance ${peek_res_x} ${peek_res_y}
  peek --start
}

shotwin () {
	cd ${dir} && maim -u -f png -i `xdotool getactivewindow` | copy_shot
	notify_view
}

shotarea () {
	cd ${dir} && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | copy_shot
	notify_view
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		screen_to_gif
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac


