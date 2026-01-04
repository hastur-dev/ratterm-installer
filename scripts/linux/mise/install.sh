#!/usr/bin/env bash
# Install script for mise on Linux (polyglot runtime manager)

set -euo pipefail

readonly SCRIPT_NAME="install.sh"

log_info() { echo "[INFO] ${SCRIPT_NAME}: $1"; }
log_error() { echo "[ERROR] ${SCRIPT_NAME}: $1" >&2; }
log_success() { echo "[SUCCESS] ${SCRIPT_NAME}: $1"; }

main() {
    log_info "Starting mise installation on Linux..."

    # Official install script
    curl https://mise.run | sh

    # Add to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"

    if command -v mise &> /dev/null; then
        log_success "mise installed: $(mise --version 2>&1)"
        log_info "Add 'eval \"\$(mise activate bash)\"' to your .bashrc"
        log_info "Or 'eval \"\$(mise activate zsh)\"' to your .zshrc"
    else
        log_error "Failed to install mise"
        exit 1
    fi

    log_success "Installation complete!"
    exit 0
}

main "$@"
