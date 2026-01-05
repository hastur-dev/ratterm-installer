# Install script for difftastic on Windows (structural diff)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "install.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogError { param($Message) Write-Host "[ERROR] ${SCRIPT_NAME}: $Message" -ForegroundColor Red }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting difftastic installation on Windows..."

    $installed = $false

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id Wilfred.difftastic --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command cargo -ErrorAction SilentlyContinue)) {
        cargo install difftastic 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command scoop -ErrorAction SilentlyContinue)) {
        scoop install difftastic 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Get-Command difft -ErrorAction SilentlyContinue) {
        Write-LogSuccess "difftastic installed: $(difft --version 2>&1)"
        Write-LogInfo "Set as git diff: git config --global diff.external difft"
    } else {
        Write-LogError "Failed to install difftastic"
        exit 1
    }

    Write-LogSuccess "Installation complete!"
    exit 0
}

Main
exit 0
