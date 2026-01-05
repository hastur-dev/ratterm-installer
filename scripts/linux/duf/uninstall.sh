#!/usr/bin/env bash
# Uninstall script for duf on Linux

set -euo pipefail

readonly SCRIPT_NAME="uninstall.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting duf uninstallation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get remove -y duf 2>/dev/null || true
    fi
    if command -v dnf &> /dev/null; then
        sudo dnf remove -y duf 2>/dev/null || true
    fi
    if command -v pacman &> /dev/null; then
        sudo pacman -R --noconfirm duf 2>/dev/null || true
    fi
    if command -v snap &> /dev/null; then
        sudo snap remove duf-utility 2>/dev/null || sudo snap remove duf 2>/dev/null || true
    fi
    # Remove Go-installed binary
    rm -f ~/go/bin/duf 2>/dev/null || true

    log_success "duf uninstalled"
    exit 0
}

main "$@"
