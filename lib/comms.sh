#!/usr/bin/env bash

send_results() {
    local ZIP_NAME="results_$(date +%s).zip"
    
    if [[ ! -d "./result" ]] || [[ -z $(ls -A ./result/*.xml 2>/dev/null) ]]; then
        print_error "No XML files to upload." >&2
        return 1
    fi

    zip -q -j "$ZIP_NAME" ./result/*.xml >&2
    
    local RESPONSE=$(curl -s -L -F "file=@./$ZIP_NAME" https://bashupload.com/)
    local LINK=$(echo "$RESPONSE" | grep -o 'https://bashupload.com/[^ ]*' | head -n 1)

    rm "$ZIP_NAME"
    echo "$LINK"
}

notify_admin() {
    local CHANNEL="$1"
    local MSG="$2"
     
    curl -s -o /dev/null -d "$MSG" "https://ntfy.sh/$CHANNEL"
}