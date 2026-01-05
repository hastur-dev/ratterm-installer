# Uninstall script for mcfly on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting mcfly uninstallation on Windows..."

    try { cargo uninstall mcfly 2>&1 | Out-Null } catch {}
    try { scoop uninstall mcfly 2>&1 | Out-Null } catch {}

    # Clean up data
    Remove-Item -Recurse -Force "$env:APPDATA\mcfly" -ErrorAction SilentlyContinue

    Write-LogSuccess "mcfly uninstalled"
    exit 0
}

Main
