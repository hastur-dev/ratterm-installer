# Install script for mcfly on Windows (intelligent shell history)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "install.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogError { param($Message) Write-Host "[ERROR] ${SCRIPT_NAME}: $Message" -ForegroundColor Red }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting mcfly installation on Windows..."

    $installed = $false

    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        cargo install mcfly 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command scoop -ErrorAction SilentlyContinue)) {
        scoop install mcfly 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Get-Command mcfly -ErrorAction SilentlyContinue) {
        Write-LogSuccess "mcfly installed: $(mcfly --version 2>&1)"
        Write-LogInfo "Add mcfly initialization to your PowerShell profile"
    } else {
        Write-LogError "Failed to install mcfly"
        exit 1
    }

    Write-LogSuccess "Installation complete!"
    exit 0
}

Main
