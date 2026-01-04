#!/usr/bin/env bash
# Install script for croc on Linux (secure file transfer)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting croc installation on Linux..."

    # Official install script
    curl https://getcroc.schollz.com | bash

    if command -v croc &> /dev/null; then
        log_success "croc installed: $(croc --version 2>&1)"
    else
        log_error "Failed to install croc"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
