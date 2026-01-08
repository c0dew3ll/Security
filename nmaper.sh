#!/usr/bin/env bash

#Default Values initialization
TARGET="targets.txt"
CONTINUE=false
SCAN_TYPE="default"

# Options declaration
OPTS=$(getopt -o t:cs: --long target:,continue,scan-type: -n "$0" -- "$@")

# Check for getopt errors:
if [ $? != 0 ]; then exit 1; fi

eval set -- "$OPTS"

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
    *)         SCAN_PARAMETERS="$SCAN_TYPE" ;; # Pozwala wpisać np. -sV bezpośrednio
esac

printf "Target: $TARGET\n"
printf "Continue: $CONTINUE\n"
printf "Scan Type: $SCAN_TYPE\n"
printf "nmap parameters: $SCAN_PARAMETERS\n"

printf "Checking for nmap...\n"
if ! command -v nmap &> /dev/null
then
    printf "\t[X] Nmap is not installed! Please install nmap and re-run!\n"
    exit 1;
else
    printf "\t[✓] Nmap installed!\n"
fi

# Check for folders
printf "Checking for required folders...\n"
## Check for Temp folder
if test -d ./temp; then
    printf "\t[✓] /temp folder present\n"
else
    mkdir temp
    printf "\t[X] /temp folder not present, created one for you.\n"
fi

## Check for Result
if test -d ./result; then
    printf "\t[✓] /result folder present\n"
else
    mkdir result
    printf "\t[X] /result folder not present, created one for you.\n"
fi

## CHeck for Target folder
if test -d ./target; then
    printf "\t[✓] /target folder present\n"
else
    mkdir target
    printf "\t[X] /target folder not present, created one for you.\n"
fi

#Read Target file

if ! test -f targets.txt; then
    printf "\t[X] No targets.txt file in target folder, so noone to scan. Exiting."
    exit 1;
fi

#Lunch nmap in loop 
file=$(cat $TARGET)
for line in $file
do
    printf "Starting scan for $line\n" 
    nmap $line $SCAN_PARAMETERS -oX ./result/${TARGET}_${line}.xml
done