#!/usr/bin/env bash
# Integration tests: Build Docker containers and run install/run scripts
# Tests actual installation and execution in isolated environments

set -euo pipefail

# Constants
readonly MAX_BUILD_ATTEMPTS=3
readonly MAX_CONTAINERS=10
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly DOCKER_DIR="${SCRIPT_DIR}/docker"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Assertion helper
assert() {
    if ! "$@"; then
        echo "Assertion failed: $*" >&2
        return 1
    fi
}

assert_true() {
    local condition="$1"
    local message="$2"

    assert [ -n "$condition" ] "condition must not be empty"
    assert [ -n "$message" ] "message must not be empty"

    ((TESTS_RUN++)) || true

    if eval "$condition"; then
        ((TESTS_PASSED++)) || true
        echo "✓ PASS: $message"
        return 0
    else
        ((TESTS_FAILED++)) || true
        echo "✗ FAIL: $message"
        return 1
    fi
}

# Build Docker image with retry
build_docker_image() {
    local dockerfile="$1"
    local image_name="$2"

    assert [ -n "$dockerfile" ] "dockerfile must not be empty"
    assert [ -n "$image_name" ] "image_name must not be empty"
    assert [ -f "$dockerfile" ] "Dockerfile must exist: $dockerfile"

    local attempt=0
    while [ $attempt -lt $MAX_BUILD_ATTEMPTS ]; do
        ((attempt++)) || true
        echo "Building ${image_name} (attempt ${attempt}/${MAX_BUILD_ATTEMPTS})..."

        if docker build -f "$dockerfile" -t "$image_name" "${SCRIPT_DIR}" 2>&1; then
            echo "Successfully built: ${image_name}"
            return 0
        fi

        echo "Build failed, retrying..."
        sleep 2
    done

    echo "ERROR: Failed to build ${image_name} after ${MAX_BUILD_ATTEMPTS} attempts"
    return 1
}

# Run container and execute install script
test_install_in_container() {
    local image_name="$1"
    local os_name="$2"

    assert [ -n "$image_name" ] "image_name must not be empty"
    assert [ -n "$os_name" ] "os_name must not be empty"

    echo "--- Testing install on ${os_name} ---"

    local container_name="test-install-${os_name}-$$"
    local exit_code=0

    # Run install script in container
    if docker run --rm --name "$container_name" "$image_name" \
        /bin/bash -c "/app/vim/install-${os_name}.sh" 2>&1; then
        exit_code=0
    else
        exit_code=$?
    fi

    assert_true "[ ${exit_code} -eq 0 ]" "Install script succeeded on ${os_name}"
    return $exit_code
}

# Run container and execute run script (verify installation)
test_run_in_container() {
    local image_name="$1"
    local os_name="$2"

    assert [ -n "$image_name" ] "image_name must not be empty"
    assert [ -n "$os_name" ] "os_name must not be empty"

    echo "--- Testing run on ${os_name} ---"

    local container_name="test-run-${os_name}-$$"
    local exit_code=0

    # Run the run script in container (after install)
    if docker run --rm --name "$container_name" "$image_name" \
        /bin/bash -c "/app/vim/install-${os_name}.sh && /app/vim/run-${os_name}.sh" 2>&1; then
        exit_code=0
    else
        exit_code=$?
    fi

    assert_true "[ ${exit_code} -eq 0 ]" "Run script succeeded on ${os_name}"
    return $exit_code
}

# Test Linux container
test_linux() {
    local image_name="install-linux"
    local dockerfile="${DOCKER_DIR}/Dockerfile.linux"

    assert [ -f "$dockerfile" ] "Linux Dockerfile must exist"

    build_docker_image "$dockerfile" "$image_name" || return 1
    test_install_in_container "$image_name" "linux" || true
    test_run_in_container "$image_name" "linux" || true
}

# Main test runner
run_integration_tests() {
    echo "========================================="
    echo "Running Docker Integration Tests"
    echo "Docker directory: ${DOCKER_DIR}"
    echo "========================================="
    echo ""

    # Check Docker is available
    if ! command -v docker &> /dev/null; then
        echo "ERROR: Docker is not installed or not in PATH"
        exit 1
    fi

    # Check Docker daemon is running
    if ! docker info &> /dev/null; then
        echo "ERROR: Docker daemon is not running"
        exit 1
    fi

    # Run Linux tests (Docker-based)
    echo ""
    echo "=== Linux Container Tests ==="
    test_linux || true

    # Summary
    echo ""
    echo "========================================="
    echo "Integration Test Summary"
    echo "========================================="
    echo "Total:  ${TESTS_RUN}"
    echo "Passed: ${TESTS_PASSED}"
    echo "Failed: ${TESTS_FAILED}"
    echo ""

    # Postcondition: verify test counts are consistent
    local total=$((TESTS_PASSED + TESTS_FAILED))
    assert [ "$total" -eq "$TESTS_RUN" ] "Test counts must be consistent"

    if [ "${TESTS_FAILED}" -eq 0 ]; then
        echo "All integration tests passed!"
        return 0
    else
        echo "Some integration tests failed!"
        return 1
    fi
}

# Entry point
main() {
    # Preconditions
    assert [ -d "${DOCKER_DIR}" ] "Docker directory must exist: ${DOCKER_DIR}"

    run_integration_tests
}

main "$@"
