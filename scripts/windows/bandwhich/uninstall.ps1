# Uninstall script for bandwhich on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting bandwhich uninstallation on Windows..."

    try { cargo uninstall bandwhich 2>&1 | Out-Null } catch {}
    try { scoop uninstall bandwhich 2>&1 | Out-Null } catch {}

    Write-LogSuccess "bandwhich uninstalled"
    exit 0
}

Main
exit 0
