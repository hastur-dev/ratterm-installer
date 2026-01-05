# Uninstall script for difftastic on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "uninstall.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting difftastic uninstallation on Windows..."

    try { winget uninstall --id Wilfred.difftastic --silent 2>&1 | Out-Null } catch {}
    try { cargo uninstall difftastic 2>&1 | Out-Null } catch {}
    try { scoop uninstall difftastic 2>&1 | Out-Null } catch {}

    Write-LogSuccess "difftastic uninstalled"
    exit 0
}

Main
exit 0
