#!/usr/bin/env bash
# Uninstall script for rclone on Linux

set -euo pipefail

readonly SCRIPT_NAME="uninstall.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting rclone uninstallation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get remove -y rclone 2>/dev/null || true
    fi
    if command -v dnf &> /dev/null; then
        sudo dnf remove -y rclone 2>/dev/null || true
    fi
    if command -v pacman &> /dev/null; then
        sudo pacman -R --noconfirm rclone 2>/dev/null || true
    fi
    sudo rm -f /usr/bin/rclone /usr/local/bin/rclone 2>/dev/null || true
    sudo rm -f /usr/share/man/man1/rclone.1 2>/dev/null || true

    log_success "rclone uninstalled"
    log_info "Config remains at ~/.config/rclone - remove manually if needed"
    exit 0
}

main "$@"
