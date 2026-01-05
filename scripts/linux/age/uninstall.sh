#!/usr/bin/env bash
# Uninstall script for age on Linux

set -euo pipefail

readonly SCRIPT_NAME="uninstall.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting age uninstallation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get remove -y age 2>/dev/null || true
    fi
    if command -v dnf &> /dev/null; then
        sudo dnf remove -y age 2>/dev/null || true
    fi
    if command -v pacman &> /dev/null; then
        sudo pacman -R --noconfirm age 2>/dev/null || true
    fi
    rm -f ~/go/bin/age ~/go/bin/age-keygen 2>/dev/null || true

    log_success "age uninstalled"
    exit 0
}

main "$@"
