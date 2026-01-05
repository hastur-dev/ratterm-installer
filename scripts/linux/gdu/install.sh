#!/usr/bin/env bash
# Install script for gdu on Linux (fast disk usage analyzer)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting gdu installation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y gdu 2>/dev/null || {
            log_info "Adding gdu PPA..."
            sudo add-apt-repository -y ppa:daniel-mstrele/gdu 2>/dev/null || true
            sudo apt-get update -y
            sudo apt-get install -y gdu 2>/dev/null || true
        }
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y gdu 2>/dev/null || true
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm gdu
    fi

    # Fallback to Go install
    if ! command -v gdu &> /dev/null && command -v go &> /dev/null; then
        log_info "Installing gdu via go install..."
        go install github.com/dundee/gdu/v5/cmd/gdu@latest
    fi

    if command -v gdu &> /dev/null; then
        log_success "gdu installed: $(gdu --version 2>&1 | head -1)"
    else
        log_error "Failed to install gdu"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
