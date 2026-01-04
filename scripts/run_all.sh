#!/usr/bin/env bash
# Master script to run all tests and builds
# Executes on Linux/macOS

set -euo pipefail

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly MAX_CONTAINERS=10
readonly MAX_RETRY_ATTEMPTS=3

# Logging
log_info() {
    local message="$1"
    if [ -z "$message" ]; then return 1; fi
    echo "[INFO] run_all.sh: ${message}"
}

log_success() {
    local message="$1"
    if [ -z "$message" ]; then return 1; fi
    echo "[SUCCESS] run_all.sh: ${message}"
}

log_error() {
    local message="$1"
    if [ -z "$message" ]; then return 1; fi
    echo "[ERROR] run_all.sh: ${message}" >&2
}

# Check toolchain versions
check_toolchains() {
    log_info "Verifying toolchains..."

    echo "  Bash: $(bash --version | head -n1)"

    if command -v docker &> /dev/null; then
        echo "  Docker: $(docker --version)"
    else
        log_error "Docker not found"
        return 1
    fi

    if command -v docker-compose &> /dev/null; then
        echo "  Docker Compose: $(docker-compose --version)"
    elif docker compose version &> /dev/null; then
        echo "  Docker Compose: $(docker compose version)"
    fi

    log_success "Toolchains verified"
}

# Run script syntax tests
run_syntax_tests() {
    log_info "Running script syntax tests..."

    local test_script="${SCRIPT_DIR}/tests/test_scripts.sh"

    if [ -f "$test_script" ]; then
        chmod +x "$test_script"
        bash "$test_script"
        log_success "Syntax tests passed"
    else
        log_error "Test script not found: ${test_script}"
        return 1
    fi
}

# Build Docker containers
build_docker_containers() {
    log_info "Building Docker containers..."

    cd "${SCRIPT_DIR}"

    local container_count=0
    local dockerfiles=(docker/Dockerfile.*)

    for dockerfile in "${dockerfiles[@]}"; do
        if [ -f "$dockerfile" ]; then
            ((container_count++)) || true

            if [ $container_count -gt $MAX_CONTAINERS ]; then
                log_error "Too many containers"
                return 1
            fi

            local os_name="${dockerfile##*.}"
            local image_name="install-${os_name}"

            log_info "Building: ${image_name}"
            docker build -f "$dockerfile" -t "$image_name" .
        fi
    done

    log_success "Built ${container_count} containers"
}

# Run install tests in containers
run_container_tests() {
    log_info "Running container tests..."

    local images=("install-linux" "install-linux-fedora")
    local passed=0
    local failed=0

    for image in "${images[@]}"; do
        log_info "Testing: ${image}"

        if docker run --rm "$image" 2>&1; then
            ((passed++)) || true
            log_success "${image} tests passed"
        else
            ((failed++)) || true
            log_error "${image} tests failed"
        fi
    done

    log_info "Container tests: ${passed} passed, ${failed} failed"

    if [ $failed -gt 0 ]; then
        return 1
    fi
}

# Run native OS tests (if applicable)
run_native_tests() {
    log_info "Running native OS tests..."

    local os_type
    os_type=$(uname -s)

    case "$os_type" in
        Linux)
            log_info "Running Linux install test..."
            chmod +x "${SCRIPT_DIR}/vim/install-linux.sh"
            chmod +x "${SCRIPT_DIR}/vim/run-linux.sh"
            # Note: Requires sudo, skip in non-root environments
            if [ "$EUID" -eq 0 ]; then
                "${SCRIPT_DIR}/vim/install-linux.sh"
                "${SCRIPT_DIR}/vim/run-linux.sh"
            else
                log_info "Skipping native install (not root)"
            fi
            ;;
        Darwin)
            log_info "Running macOS install test..."
            chmod +x "${SCRIPT_DIR}/vim/install-macos.sh"
            chmod +x "${SCRIPT_DIR}/vim/run-macos.sh"
            "${SCRIPT_DIR}/vim/install-macos.sh"
            "${SCRIPT_DIR}/vim/run-macos.sh"
            ;;
        *)
            log_info "Native tests not supported on: ${os_type}"
            ;;
    esac

    log_success "Native tests completed"
}

# Main entry point
main() {
    log_info "Starting run_all.sh..."
    log_info "Script directory: ${SCRIPT_DIR}"

    # Verify toolchains
    check_toolchains

    # Run syntax tests
    run_syntax_tests

    # Build containers
    build_docker_containers

    # Run container tests
    run_container_tests

    # Run native tests (optional)
    run_native_tests || true

    log_success "All tests completed!"
}

main "$@"
