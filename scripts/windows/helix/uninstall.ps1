# Uninstall script for helix on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting helix uninstallation on Windows..."

    try { winget uninstall --id Helix.Helix --silent 2>&1 | Out-Null } catch {}
    try { choco uninstall helix -y --no-progress 2>&1 | Out-Null } catch {}
    try { scoop uninstall helix 2>&1 | Out-Null } catch {}

    Write-LogSuccess "helix uninstalled"
    exit 0
}

Main
exit 0
