#!/usr/bin/env bash
# Install script for rclone on Linux (cloud storage sync)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting rclone installation on Linux..."

    # Official install script
    curl https://rclone.org/install.sh | sudo bash

    if command -v rclone &> /dev/null; then
        log_success "rclone installed: $(rclone --version 2>&1 | head -1)"
        log_info "Run 'rclone config' to set up cloud providers"
    else
        log_error "Failed to install rclone"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
