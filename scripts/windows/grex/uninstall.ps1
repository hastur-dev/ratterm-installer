# Uninstall script for grex on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting grex uninstallation on Windows..."

    try { cargo uninstall grex 2>&1 | Out-Null } catch {}
    try { scoop uninstall grex 2>&1 | Out-Null } catch {}
    try { choco uninstall grex -y --no-progress 2>&1 | Out-Null } catch {}

    Write-LogSuccess "grex uninstalled"
    exit 0
}

Main
exit 0
