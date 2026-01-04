#!/usr/bin/env bash
# Uninstall script for direnv on Linux

set -euo pipefail

readonly SCRIPT_NAME="uninstall.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting direnv uninstallation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get remove -y direnv 2>/dev/null || true
    fi
    if command -v dnf &> /dev/null; then
        sudo dnf remove -y direnv 2>/dev/null || true
    fi
    if command -v pacman &> /dev/null; then
        sudo pacman -R --noconfirm direnv 2>/dev/null || true
    fi

    log_success "direnv uninstalled"
    log_info "Remember to remove the direnv hook from your shell config"
    exit 0
}

main "$@"
