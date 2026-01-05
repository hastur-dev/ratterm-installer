# Install script for bandwhich on Windows (bandwidth monitor)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "install.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogError { param($Message) Write-Host "[ERROR] ${SCRIPT_NAME}: $Message" -ForegroundColor Red }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting bandwhich installation on Windows..."

    $installed = $false

    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        cargo install bandwhich 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command scoop -ErrorAction SilentlyContinue)) {
        scoop install bandwhich 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Get-Command bandwhich -ErrorAction SilentlyContinue) {
        Write-LogSuccess "bandwhich installed: $(bandwhich --version 2>&1)"
        Write-LogInfo "Run as Administrator for full functionality"
    } else {
        Write-LogError "Failed to install bandwhich"
        exit 1
    }

    Write-LogSuccess "Installation complete!"
    exit 0
}

Main
exit 0
