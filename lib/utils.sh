#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { printf "${BLUE}[i]${NC} %s\n" "$1" >&2; }
print_success() { printf "${GREEN}[✓]${NC} %s\n" "$1" >&2; }
print_error() { printf "${RED}[X]${NC} %s\n" "$1" >&2; }

encrypt_msg() {
    echo "$1" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass "pass:$2" 2>/dev/null
}