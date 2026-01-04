#!/usr/bin/env bash
# Uninstall script for mise on Linux

set -euo pipefail

readonly SCRIPT_NAME="uninstall.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting mise uninstallation on Linux..."

    rm -rf ~/.local/share/mise 2>/dev/null || true
    rm -f ~/.local/bin/mise 2>/dev/null || true
    rm -rf ~/.config/mise 2>/dev/null || true
    rm -rf ~/.cache/mise 2>/dev/null || true

    log_success "mise uninstalled"
    log_info "Remember to remove the mise activation from your shell config"
    exit 0
}

main "$@"
