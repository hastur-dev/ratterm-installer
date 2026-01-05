# Uninstall script for gdu on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting gdu uninstallation on Windows..."

    try { scoop uninstall gdu 2>&1 | Out-Null } catch {}
    try { choco uninstall gdu -y --no-progress 2>&1 | Out-Null } catch {}

    Write-LogSuccess "gdu uninstalled"
    exit 0
}

Main
exit 0
