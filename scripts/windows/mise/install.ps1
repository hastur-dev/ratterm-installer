# Install script for mise on Windows (polyglot runtime manager)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SCRIPT_NAME = "install.ps1"

function Write-LogInfo { param($Message) Write-Host "[INFO] ${SCRIPT_NAME}: $Message" }
function Write-LogError { param($Message) Write-Host "[ERROR] ${SCRIPT_NAME}: $Message" -ForegroundColor Red }
function Write-LogSuccess { param($Message) Write-Host "[SUCCESS] ${SCRIPT_NAME}: $Message" -ForegroundColor Green }

function Main {
    Write-LogInfo "Starting mise installation on Windows..."

    $installed = $false

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id jdx.mise --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command scoop -ErrorAction SilentlyContinue)) {
        scoop install mise 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    if (-not $installed -and (Get-Command choco -ErrorAction SilentlyContinue)) {
        choco install mise -y --no-progress 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { $installed = $true }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (Get-Command mise -ErrorAction SilentlyContinue) {
        Write-LogSuccess "mise installed: $(mise --version 2>&1)"
        Write-LogInfo "Add mise activation to your PowerShell profile"
    } else {
        Write-LogError "Failed to install mise"
        exit 1
    }

    Write-LogSuccess "Installation complete!"
    exit 0
}

Main
