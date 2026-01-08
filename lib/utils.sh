#!/usr/bin/env bash

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- UI Functions ---
print_success() {
    printf "${GREEN}[✓]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[X]${NC} %s\n" "$1"
}

print_info() {
    printf "${BLUE}[i]${NC} %s\n" "$1"
}

# --- Help Menu ---
usage() {
    printf "${YELLOW}NMAPER WRAPPER v1.0${NC}\n"
    printf "Usage: $0 [OPTIONS]\n\n"
    printf "Options:\n"
    printf "  -t, --target <file>      Path to targets (default: targets.txt)\n"
    printf "  -c, --continue           Enable continue mode\n"
    printf "  -s, --scan-type <type>   Scan profile: default, fast, full, zombie\n"
    printf "  -h, --help               Show this help message\n\n"
    printf "Examples:\n"
    printf "  $0 -t internal_ips.txt -s fast\n"
    printf "  $0 --scan-type \"-sV -A\"\n"
    exit 0
}

# --- Validation Functions ---
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        print_error "Tool '$1' is not installed. Please install it."
        exit 1
    fi
}