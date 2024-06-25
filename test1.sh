#!/bin/bash

# Initialize associative array to store modifiers and their keys
declare -A modmap

# Parse `xmodmap -pm` output
echo "Parsing output from xmodmap -pm:"
xmodmap -pm

echo "Attempting to capture modifiers and their keys..."
while IFS= read -r line; do
    echo "Processing line: $line"
    # Regex to capture the modifier line more robustly
    if [[ "$line" =~ ^([a-zA-Z0-9]+)[[:space:]]+ ]]; then
        modifier="${BASH_REMATCH[1]}"
        # Capture the rest of the line after the modifier name to get all associated keys
        keys="${line#*$modifier}" # Remove the first occurrence of modifier and space
        keys="${keys//(/}"  # Remove all occurrences of '('
        keys="${keys//)/}"  # Remove all occurrences of ')'
        keys="${keys//,}"   # Remove all commas
        modmap["$modifier"]="$keys"
        echo "Captured: $modifier with keys $keys"
    fi
done < <(xmodmap -pm)

# Display all modifiers and their associated keys
echo "Modifier map: ${modmap[*]}"
# echo "Modifier map:"
# for mod in "${!modmap[@]}"; do
#     echo "$mod : ${modmap[$mod]}"
# done

if [[ ${#modmap[@]} -eq 0 ]]; then
    echo "No modifiers were captured. Please check the output format of xmodmap -pm."
fi

# Processing xinput
xinput test-xi2 --root | while IFS= read -r line; do
	if [[ "$line" =~ ^.*EVENT\ type\ ([0-9]+) ]]; then
		event_type="${BASH_REMATCH[1]}"
	fi
	if [[ "$line" =~ detail:\ ([0-9]+) ]]; then
		detail="${BASH_REMATCH[1]}"
	fi
	if [[ "$line" =~ modifiers:.*effective:\ ([0-9a-fx]+) ]]; then
		effective_mods="${BASH_REMATCH[1]}"
		effective_mods=$((16#${effective_mods##0x}))                # Proper handling of hex value
		if [[ "$event_type" == "2" || "$event_type" == "3" ]]; then # Assuming 2 is KeyPress, 3 is KeyRelease
			mods_active=()
			for mod_index in "${!modmap[@]}"; do
				if ((effective_mods & (1 << mod_index))); then
					mods_active+=("${modmap[$mod_index]}")
				fi
			done
			echo "Event Type: $event_type, Key code: $detail, Key symbol: [${keymap[$detail]}], State: $effective_mods, Active Mods: [${mods_active[*]}]"
		fi
	fi
done
