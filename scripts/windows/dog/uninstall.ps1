# Uninstall script for dog on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting dog uninstallation on Windows..."

    try { cargo uninstall dog 2>&1 | Out-Null } catch {}
    try { scoop uninstall dog 2>&1 | Out-Null } catch {}

    Write-LogSuccess "dog uninstalled"
    exit 0
}

Main
