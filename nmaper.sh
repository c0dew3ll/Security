#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")
LIB_DIR="$BASE_DIR/lib"

if [[ -f "${LIB_DIR}/utils.sh" ]]; then
    source "${LIB_DIR}/utils.sh"
else
    echo "Error: utils.sh not found in ${LIB_DIR}"
    exit 1
fi

#Default Values initialization
TARGET="targets.txt"
CONTINUE=false
SCAN_TYPE="default"

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
    -s|--scan-type)
      SCAN_TYPE="$2"
      shift 2
      ;;
    -h|--help) # Obsługa pomocy
      usage
      ;;
    *)
      printf "[!] Unknown option: $1"
      usage # Wyświetla pomoc przy błędnym argumencie
      ;;
  esac
done

# Parse Arguments
while true; do
  case "$1" in
    -t | --target )    TARGET="$2"; shift 2 ;;
    -c | --continue )  CONTINUE=true; shift ;;
    -s | --scan-type ) SCAN_TYPE="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

#Parse SCAN_PARAMETERS
case "$SCAN_TYPE" in
    "default") SCAN_PARAMETERS="-sT -p1-1000" ;;
    "fast")    SCAN_PARAMETERS="-F" ;;
    "full")    SCAN_PARAMETERS="-p-" ;;
    "zombie")  SCAN_PARAMETERS="-sI ${ZOMBIE_IP} -Pn -f --data-lenght 32 -g" ;;
    *)         SCAN_PARAMETERS="$SCAN_TYPE" ;; # Pozwala wpisać np. -sV bezpośrednio
esac

print_info "Target: $TARGET"
print_info "Continue: $CONTINUE"
print_info "Scan Type: $SCAN_TYPE"
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

if ! test -f targets.txt; then
    print_error "[X] No targets.txt file in target folder, so noone to scan. Exiting."
    exit 1;
fi

#Lunch nmap in loop 
file=$(cat $TARGET)
for line in $file
do
    print_info "Starting scan for $line" 
    TARGET_FILENAME="${TARGET##*/}"
    nmap $line $SCAN_PARAMETERS -oX ./result/${TARGET_FILENAME}_${line}.xml
done