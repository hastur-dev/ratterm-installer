#!/usr/bin/env bash
# Uninstall script for gdu on Linux

set -euo pipefail

readonly SCRIPT_NAME="uninstall.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting gdu uninstallation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get remove -y gdu 2>/dev/null || true
    fi
    if command -v dnf &> /dev/null; then
        sudo dnf remove -y gdu 2>/dev/null || true
    fi
    if command -v pacman &> /dev/null; then
        sudo pacman -R --noconfirm gdu 2>/dev/null || true
    fi
    rm -f ~/go/bin/gdu 2>/dev/null || true

    log_success "gdu uninstalled"
    exit 0
}

main "$@"
