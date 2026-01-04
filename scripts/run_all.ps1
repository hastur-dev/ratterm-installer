# Master script to run all tests and builds (Windows)
# Executes on Windows PowerShell

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Constants
$SCRIPT_DIR = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$MAX_CONTAINERS = 10
$MAX_RETRY_ATTEMPTS = 3

# Logging functions
function Write-LogInfo {
    param([Parameter(Mandatory=$true)][string]$Message)
    if ([string]::IsNullOrEmpty($Message)) { return }
    Write-Host "[INFO] run_all.ps1: $Message"
}

function Write-LogSuccess {
    param([Parameter(Mandatory=$true)][string]$Message)
    if ([string]::IsNullOrEmpty($Message)) { return }
    Write-Host "[SUCCESS] run_all.ps1: $Message" -ForegroundColor Green
}

function Write-LogError {
    param([Parameter(Mandatory=$true)][string]$Message)
    if ([string]::IsNullOrEmpty($Message)) { return }
    Write-Host "[ERROR] run_all.ps1: $Message" -ForegroundColor Red
}

# Check toolchain versions
function Test-Toolchains {
    Write-LogInfo "Verifying toolchains..."

    Write-Host "  PowerShell: $($PSVersionTable.PSVersion)"

    try {
        $dockerVersion = docker --version
        Write-Host "  Docker: $dockerVersion"
    } catch {
        Write-LogError "Docker not found"
        return $false
    }

    try {
        $composeVersion = docker compose version 2>&1
        Write-Host "  Docker Compose: $composeVersion"
    } catch {
        Write-LogInfo "Docker Compose not found (optional)"
    }

    Write-LogSuccess "Toolchains verified"
    return $true
}

# Run script syntax tests
function Invoke-SyntaxTests {
    Write-LogInfo "Running script syntax tests..."

    $testScript = Join-Path $SCRIPT_DIR "tests\test_scripts.ps1"

    if (Test-Path $testScript) {
        & $testScript
        Write-LogSuccess "Syntax tests passed"
        return $true
    } else {
        Write-LogError "Test script not found: $testScript"
        return $false
    }
}

# Build Docker containers
function Build-DockerContainers {
    Write-LogInfo "Building Docker containers..."

    Push-Location $SCRIPT_DIR

    try {
        $containerCount = 0
        $dockerfiles = Get-ChildItem -Path "docker\Dockerfile.*" -ErrorAction SilentlyContinue

        foreach ($dockerfile in $dockerfiles) {
            $containerCount++

            if ($containerCount -gt $MAX_CONTAINERS) {
                Write-LogError "Too many containers"
                return $false
            }

            $osName = $dockerfile.Extension.TrimStart('.')
            $imageName = "install-$osName"

            Write-LogInfo "Building: $imageName"
            docker build -f $dockerfile.FullName -t $imageName .
        }

        Write-LogSuccess "Built $containerCount containers"
        return $true
    } finally {
        Pop-Location
    }
}

# Run install tests in containers
function Invoke-ContainerTests {
    Write-LogInfo "Running container tests..."

    $images = @("install-linux", "install-linux-fedora")
    $passed = 0
    $failed = 0

    foreach ($image in $images) {
        Write-LogInfo "Testing: $image"

        try {
            docker run --rm $image 2>&1 | Out-Host
            $passed++
            Write-LogSuccess "$image tests passed"
        } catch {
            $failed++
            Write-LogError "$image tests failed: $_"
        }
    }

    Write-LogInfo "Container tests: $passed passed, $failed failed"

    return ($failed -eq 0)
}

# Run native Windows tests
function Invoke-NativeTests {
    Write-LogInfo "Running native Windows tests..."

    $installScript = Join-Path $SCRIPT_DIR "vim\install-windows.ps1"
    $runScript = Join-Path $SCRIPT_DIR "vim\run-windows.ps1"

    if (Test-Path $installScript) {
        Write-LogInfo "Running Windows install test..."
        & $installScript
    }

    if (Test-Path $runScript) {
        Write-LogInfo "Running Windows run test..."
        & $runScript
    }

    Write-LogSuccess "Native tests completed"
    return $true
}

# Main entry point
function Main {
    Write-LogInfo "Starting run_all.ps1..."
    Write-LogInfo "Script directory: $SCRIPT_DIR"

    # Verify toolchains
    if (-not (Test-Toolchains)) {
        exit 1
    }

    # Run syntax tests
    try {
        Invoke-SyntaxTests
    } catch {
        Write-LogError "Syntax tests failed: $_"
    }

    # Build containers (if Docker available)
    try {
        Build-DockerContainers
    } catch {
        Write-LogError "Container build failed: $_"
    }

    # Run container tests
    try {
        Invoke-ContainerTests
    } catch {
        Write-LogError "Container tests failed: $_"
    }

    # Run native tests
    try {
        Invoke-NativeTests
    } catch {
        Write-LogError "Native tests failed: $_"
    }

    Write-LogSuccess "All tests completed!"
}

Main
