#!/bin/bash

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
    local shifted_char="${keysyms[4]}"  # indices start at 0, so [4] is the 5th element

    echo "$shifted_char"
}

# Example usage:
key='4'
shifted=$(get_shifted_character "$key")
echo "Shift+'$key' results in '$shifted'"
