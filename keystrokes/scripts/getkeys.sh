#!/bin/bash

basedir="$HOME/.local/share/bubbly"

. "$HOME/.config/bubbly/keystrokes"

gradient=$("$basedir/keystrokes/scripts/gen_gradient.sh" "$keystrokes_bg")

# variables
keycodes_list=$(awk '$1 == "keycode" {print $2,$4}' "$basedir/keycodes")
previous_key=''

keys_file=/tmp/bubbly_keys

# This script retrieves the shifted character for a given key using xmodmap

# Function to get shifted character for a given key
get_shifted_character() {
	local key="$1"
	# Retrieve the line from xmodmap output that contains the unshifted key
	local line=$(xmodmap -pke | grep -E " = $key " | head -n 1)
	if [[ -z "$line" ]]; then
		echo "No key mapping found for '$key'"
		return 1
	fi

	# Split the line to get all keysyms assigned to the keycode
	local keysyms=($line)
	# Shifted character is typically at the 3rd position in the keysyms array
	local shifted_char="${keysyms[4]}" # indices start at 0, so [4] is the 5th element

	echo "$shifted_char"
}

parse_keys() {

	IFS=' ' read -r -a modifiers <<<"$2"
	echo "parse_keys - modifiers=${modifiers[*]}"
	key="$1"
	echo "parse_keys - key: $key"

	# handle modifiers
	# loop through the modifiers array and shorten the modifier names
	for i in "${!modifiers[@]}"; do
		case ${modifiers[i]} in
		Shift | Shift_L | Shift_R) modifiers[$i]="Sft" ;;
		Alt_L | Alt_R) modifiers[$i]="Alt" ;;
		Super_L | Super_R) modifiers[$i]="Super" ;;
		Control | Control_L | Control_RL | Control_R) modifiers[$i]="Ctrl" ;;
		esac
	done

	echo "parse_keys - after shortening modifiers=${modifiers[*]}"

	# If modifiers array has "Shift" then capitalize the key, and empty the modifier
	if [[ ${#modifiers[@]} -eq 1 ]] && [[ "${modifiers[0]}" == "Sft" ]]; then
		key=$(get_shifted_character "$key")
		modifiers=()
	fi

	echo "parse_keys - after handling Shift key=$key"

	# shorten some key names
	case $key in
	comma) key="," ;; period) key="." ;;
	grave) key="\`" ;; asciitilde) key="~" ;;
	less) key="<" ;; greater) key=">" ;; question) key="?" ;;
	slash) key="/" ;; backslash) key="\\" ;; bar) key="|" ;;
	minus) key="-" ;; BackSpace) key="" ;; Escape) key="Esc" ;;
	apostrophe) key="\'" ;; quotedbl) key='\"' ;;
	braceleft) key="{" ;; braceright) key="}" ;;
	bracketleft) key="[" ;; bracketright) key="]" ;;
	colon) key=":" ;; semicolon) key=";" ;;
	exclam) key="!" ;; at) key="@" ;; numbersign) key="#" ;;
	dollar) key="$" ;; percent) key="%" ;; asciicircum) key="^" ;;
	ampersand) key="&" ;; asterisk) key="*" ;;
	parenleft) key="(" ;; parenright) key=")" ;;
		# Do not show the modifiers
	Shift_L | Shift_R) key="" ;;
	Alt_L | Alt_R) key="" ;;
	Super_L | Super_R) key="" ;;
	Control_L | Control_RL | Control_R) key="" ;;
	Tab) key="⇄" ;;
	Return) key="↵" ;;
	Delete) key="Del" ;;
	Up) key="↑" ;;
	Down) key="↓" ;;
	Left) key="←" ;;
	Right) key="→" ;;
	esac

	echo "parse_keys - after shortening key=$key"

	# concatenate modifiers with key separated by '+' sign
	if [[ ${#modifiers[@]} -gt 0 ]]; then
		# Join all array elements with '+' and concatenate with key
		key=$(
			IFS='+'
			echo "${modifiers[*]}+$key"
		)
	fi

	echo "parse_keys 1: $key"

	if [ ${#key} -gt 0 ]; then
		echo -n " $key" >>$keys_file
		keys=$(cat $keys_file)
		echo "keys: $keys"

		echo "previous_key: $previous_key"
		# Handle the case where the user presses Ctrl+Esc twice to close the widgets
		if [[ "$key" = "Ctrl+Esc" ]] && [[ "$previous_key" = "Ctrl+Esc" ]]; then
			eww -c "$basedir/bubbles" close bubbly
			eww -c "$basedir/keystrokes" close keystrokes
			eww -c "$basedir/selector" update mode=''
			killall getkeys.sh
		fi

		# Update the monitor number for the keystrokes widget
		if [[ "$key" = "Sft+Ctrl+Alt+"* ]]; then
			cur_monitor=$(echo "$key" | cut -d'+' -f4)
			if [[ $cur_monitor =~ ^[0-9]+$ ]]; then
				eww -c "$basedir/keystrokes" close keystrokes
				eww -c "$basedir/keystrokes" open keystrokes --screen "$cur_monitor"
			fi
		fi

		echo "keystrokes_limit: $keystrokes_limit"
		key_widgets_list=""
		recent_words=$(echo "$keys" | rev | cut -d' ' -f-"$keystrokes_limit" | rev) # get last 3 only
		words_len=$(echo "$recent_words" | wc -w)
		index=0

		for word in $recent_words; do
			css=""
			index=$((index + 1))

			if [ $index -eq "$words_len" ]; then
				css="color: #EF8891; background: #282c34"
			fi

			# active_style=""
			key_widget="(label :show-truncated false :class 'label' :style '$css' :text '$word')"
			key_widgets_list=" $key_widgets_list $key_widget "
		done

		result="(box :hexpand true :spacing 10 :style '$gradient' :class 'keybox' :space-evenly false $key_widgets_list )"
		echo "$result"
		eww -c "$basedir/keystrokes" update keys="$result"

		echo -n "$(date '+%s')" >/tmp/bubbly_chat_timeout
	fi

	previous_key=$key
}

"$basedir"/keystrokes/scripts/perl_get_keys.sh | while IFS=':' read -r key modifiers; do
	parse_keys "$key" "$modifiers"
done

# if the user doesnt type for 2 seconds then hide eww widget
check_keypress_timeout() {
	while true; do
		timeout=$(cat /tmp/bubbly_chat_timeout)
		timenow=$(date '+%s')
		time_diff=$((timenow - timeout))

		if [ "$time_diff" -ge 1 ]; then
			echo "2: $time_diff"
			eww -c "$basedir/keystrokes" update keys=" "
			eww -c "$basedir/keystrokes" reload
			echo -n "" >$keys_file
		fi

		sleep 1
	done
}

check_keypress_timeout &
