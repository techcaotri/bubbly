#!/bin/dash

# parse_keys() {
# 	read -r line

# 	key_code=$(echo "$line" | awk -F ' ' '/key press/ {print $NF}')
# 	key=$(echo "$keycodes_list" | awk -v keycode="$key_code" '$1 == keycode {print $2}')

#   echo "parse_keys 1: $key"
# }

# device=$(xinput --list --long | grep XIKeyClass | head -n 1 | grep -E -o '[0-9]+')
# echo "1: $device"

# xinput test "$device" | while parse_keys; do :; done &

# xinput test-xi2 --root | gawk '
# BEGIN { print "Listening for keyboard events..."; }
# /^.*RawKeyRelease.*$/ {
#     getline; getline; key_code=$2; getline; getline; getline; state=$3;
#     print "Key Code: " key_code " State: " state; fflush();
# }'
xinput test-xi2 --root | gawk '
BEGIN { print "Listening for keyboard events..."; }
/ EVENT type 2/ { # Looking for KeyPress events which are type 2
    getline; # Read next line where actual data starts
    if ($1 == "detail:") {
        key_code = $2;
        getline; getline; # Move to the state line
        if ($1 == "mods:") {
            getline; # State details are on the next line
            state = $3; # Capture state value
            print "Key Code: " key_code " State: " state; fflush();
        }
    }
}'
