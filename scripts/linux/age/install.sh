#!/usr/bin/env bash
# Install script for age on Linux (file encryption tool)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting age installation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y && sudo apt-get install -y age
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y age
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm age
    elif command -v go &> /dev/null; then
        go install filippo.io/age/cmd/...@latest
    fi

    if command -v age &> /dev/null; then
        log_success "age installed: $(age --version 2>&1)"
    else
        log_error "Failed to install age"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
