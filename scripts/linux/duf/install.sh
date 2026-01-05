#!/usr/bin/env bash
# Install script for duf on Linux (modern df alternative)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting duf installation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y && sudo apt-get install -y duf || {
            log_info "duf not in apt, trying snap..."
            sudo snap install duf-utility 2>/dev/null || sudo snap install duf 2>/dev/null || true
        }
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y duf 2>/dev/null || true
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm duf
    fi

    # Fallback to Go install if available
    if ! command -v duf &> /dev/null && command -v go &> /dev/null; then
        log_info "Installing duf via go install..."
        go install github.com/muesli/duf@latest
    fi

    if command -v duf &> /dev/null; then
        log_success "duf installed: $(duf --version 2>&1 | head -1)"
    else
        log_error "Failed to install duf"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
