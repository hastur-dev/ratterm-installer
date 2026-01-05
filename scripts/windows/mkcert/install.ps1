# Install script for mkcert on Windows (local dev certificates)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "install.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogError { param($Message) Write-Host "[ERROR] ${SCRIPT_NAME}: $Message" -ForegroundColor Red }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting mkcert installation on Windows..."

    $installed = $false

    if (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install mkcert -y --no-progress 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command scoop -ErrorAction SilentlyContinue)) {
        scoop bucket add extras 2>&1 | Out-Null
        scoop install mkcert 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Get-Command mkcert -ErrorAction SilentlyContinue) {
        Write-LogSuccess "mkcert installed: $(mkcert --version 2>&1)"
        Write-LogInfo "Run 'mkcert -install' to install the local CA"
    } else {
        Write-LogError "Failed to install mkcert"
        exit 1
    }

    Write-LogSuccess "Installation complete!"
    exit 0
}

Main
exit 0
