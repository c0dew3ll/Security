#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")
LIB_DIR="$BASE_DIR/lib"

LIBS=("utils.sh" "comms.sh")

for lib in "${LIBS[@]}"; do
    if [[ -f "${LIB_DIR}/$lib" ]]; then
        source "${LIB_DIR}/$lib"
    else
        echo "Error: ${lib} not found in ${LIB_DIR}"
        exit 1
    fi
done

#Default Values initialization
TARGET="targets.txt"
CONTINUE=false
UPLOAD=false
SCAN_TYPE="default"
ENCRYPT_PASS="ChangeMe123!"
STATIONARY_ROOM="UUID_222222222"
PRESERVE_HISTORY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)
      TARGET="$2"
      shift 2
      ;;
    -c|--continue)
      CONTINUE=true
      shift
      ;;
    -u|--upload)
      UPLOAD=true
      shift
      ;;
    -s|--scan-type)
      SCAN_TYPE="$2"
      shift 2
      ;;
    -r|--room-name)
      STATIONARY_ROOM="$2"
      shift 2
      ;;
    -p|--password)
      ENCRYPT_PASS="$2"
      shift 2
      ;;
    -k|--keep-history)
      PRESERVE_HISTORY=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      printf "[!] Unknown option: $1"
      usage
      ;;
  esac
done

#Parse SCAN_PARAMETERS
#TODO Zombie scan
case "$SCAN_TYPE" in
    "default") SCAN_PARAMETERS="-sT -p1-1000" ;;
    "fast")    SCAN_PARAMETERS="-F" ;;
    "full")    SCAN_PARAMETERS="-p-" ;;
    "zombie")  SCAN_PARAMETERS="-sI ${ZOMBIE_IP} -Pn -f --data-length 32 -g 53" ;;
    *)         SCAN_PARAMETERS="$SCAN_TYPE" ;;
esac

print_info "Target: $TARGET"
print_info "Continue: $CONTINUE"
print_info "Scan Type: $SCAN_TYPE"
print_info "Upload: $UPLOAD"
print_info "nmap parameters: $SCAN_PARAMETERS"

print_info "Checking for nmap..."
if ! command -v nmap &> /dev/null
then
    print_error "[X] Nmap is not installed! Please install nmap and re-run!"
    exit 1;
else
    print_success "[✓] Nmap installed!"
fi

# Check for folders
print_info "Checking for required folders..."
## Check for Temp folder
if test -d ./temp; then
    print_success "[✓] /temp folder present"
else
    mkdir temp
    print_error "[X] /temp folder not present, created one for you."
fi

## Check for Result
if test -d ./result; then
    print_success "[✓] /result folder present"
else
    mkdir result
    print_error "[X] /result folder not present, created one for you."
fi

## CHeck for Target folder
if test -d ./target; then
    print_success "[✓] /target folder present"
else
    mkdir target
    print_error "[X] /target folder not present, created one for you."
fi

#Read Target file

#TODO fix that. If usewr provide filename, and there is no targets.txt, it will fail
if [[ ! -f "$TARGET" ]]; then
    print_error "[X] Target file $TARGET not found. Exiting."
    exit 1
fi

#Lunch nmap in loop 
TARGET_FILENAME="${TARGET##*/}"
while read -r line || [[ -n "$line" ]]; do
    # Pomijaj puste linie i komentarze
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    print_info "Starting scan for $line" 
    nmap $line $SCAN_PARAMETERS -oX "./result/${TARGET_FILENAME}_${line}.xml"
done < "$TARGET"

if [[ "$UPLOAD" == true ]]; then
    print_info "Exfiltrating data..."
    
    RAW_LINK=$(send_results)

    if [[ -n "$RAW_LINK" && "$RAW_LINK" == http* ]]; then
        CIPHER_TEXT=$(encrypt_msg "$RAW_LINK" "$ENCRYPT_PASS")
        
        notify_admin "$STATIONARY_ROOM" "NEW_REPORT: $CIPHER_TEXT"
        print_success "Data sent to ntfy.sh room: $STATIONARY_ROOM"
        
        if [[ "$KEEP_HISTORY" == false ]]; then
            rm -rf ./result/*.xml
            rm -rf ./temp/*
            print_info "Local traces removed."
        fi
    else
        print_error "Exfiltration failed! RAW_LINK is empty or invalid."
    fi
fi