#!/usr/bin/env bash
action_base64() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: spin base64 encode filename"
        echo "       spin base64 decode [filename|base64string]"
        return 1
    fi

    local action=$1
    local input=$2

    if [[ "$(uname -s)" == "Darwin" ]]; then
      local base64_encode_cmd="base64 -i"
      local base64_decode_cmd="base64 -D"
    else
      local base64_encode_cmd="base64"
      local base64_decode_cmd="base64 -d"
    fi

    case "$action" in
        encode | -e)
            # Check if the file exists for encoding
            if [ ! -f "$input" ]; then
                echo "Error: File '$input' not found."
                return 1
            fi
            # Encode the file with base64
            $base64_encode_cmd "$input"
            ;;
        decode | -d)
            # Decode the input
            if [ -f "$input" ]; then
                # If it's a file, decode the file contents
                cat "$input" | $base64_decode_cmd 
            else
                # If it's not a file, assume it's a base64 string and try to decode it
                echo "$input" | $base64_decode_cmd 2>/dev/null
                if [ $? -ne 0 ]; then
                    echo "Error: Input is not a valid base64 string."
                    return 1
                fi
            fi
            ;;
        *)
            # Display help menu if invalid action is provided
            echo "Invalid action. Valid actions are 'encode' or 'decode'."
            echo "Usage: spin base64 encode filename"
            echo "       spin base64 decode [filename|base64string]"
            return 1
            ;;
    esac
}