#!/usr/bin/env bash
# Install script for direnv on Linux (directory-based env vars)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting direnv installation on Linux..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y && sudo apt-get install -y direnv
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y direnv
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm direnv
    fi

    if command -v direnv &> /dev/null; then
        log_success "direnv installed: $(direnv --version 2>&1)"
        log_info "Add 'eval \"\$(direnv hook bash)\"' to your .bashrc"
        log_info "Or 'eval \"\$(direnv hook zsh)\"' to your .zshrc"
    else
        log_error "Failed to install direnv"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
