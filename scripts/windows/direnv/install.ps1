# Install script for direnv on Windows (directory-based env vars)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "install.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogError { param($Message) Write-Host "[ERROR] ${SCRIPT_NAME}: $Message" -ForegroundColor Red }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting direnv installation on Windows..."

    $installed = $false

    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install direnv 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        choco install direnv -y --no-progress 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Get-Command direnv -ErrorAction SilentlyContinue) {
        Write-LogSuccess "direnv installed: $(direnv --version 2>&1)"
        Write-LogInfo "Add direnv hook to your shell profile"
    } else {
        Write-LogError "Failed to install direnv"
        exit 1
    }

    Write-LogSuccess "Installation complete!"
    exit 0
}

Main
