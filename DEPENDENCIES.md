# Dependencies

This document lists all required dependencies for the Ratterm Installer project.

## System Requirements

### Linux

| Dependency | Purpose | Minimum Version | Install Command |
|------------|---------|-----------------|-----------------|
| Bash | Script execution | 4.0+ | Pre-installed |
| sudo | Elevated privileges | Any | Pre-installed |
| curl | HTTP downloads | Any | `apt install curl` |
| Docker | Container runtime | 20.0+ | See below |

**Package Managers (one required):**
- apt-get (Debian/Ubuntu)
- dnf (Fedora/RHEL 8+)
- yum (RHEL 7/CentOS)
- pacman (Arch Linux)

**Docker Installation:**
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Fedora
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```

### macOS

| Dependency | Purpose | Minimum Version | Install Command |
|------------|---------|-----------------|-----------------|
| Bash | Script execution | 4.0+ | Pre-installed |
| curl | HTTP downloads | Any | Pre-installed |
| Homebrew | Package manager | 3.0+ | See below |
| Docker Desktop | Container runtime | 4.0+ | Download from docker.com |

**Homebrew Installation:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Windows

| Dependency | Purpose | Minimum Version | Install Command |
|------------|---------|-----------------|-----------------|
| PowerShell | Script execution | 5.1+ | Pre-installed |
| winget | Package manager | 1.0+ | Pre-installed (Win11) |
| Chocolatey | Package manager (fallback) | 1.0+ | See below |
| Docker Desktop | Container runtime | 4.0+ | Download from docker.com |

**Chocolatey Installation (PowerShell as Admin):**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

## CI/CD Dependencies

### GitHub Actions

The CI workflow uses these runners:
- `ubuntu-latest` - Linux testing
- `macos-latest` - macOS testing
- `windows-latest` - Windows testing

### Required Actions

| Action | Version | Purpose |
|--------|---------|---------|
| `actions/checkout` | v4 | Repository checkout |

## Docker Images

### Base Images Used

| Image | Version | Purpose |
|-------|---------|---------|
| `ubuntu` | 22.04 | Primary Linux container |
| `fedora` | 39 | Fedora testing container |
| `alpine` | 3.19 | Minimal Linux container |

## Application Being Installed

### Vim

The default application installed by this framework is Vim.

| Platform | Package Name | Package Manager |
|----------|--------------|-----------------|
| Linux (apt) | `vim` | apt-get |
| Linux (dnf) | `vim` | dnf |
| Linux (yum) | `vim` | yum |
| Linux (pacman) | `vim` | pacman |
| macOS | `vim` | Homebrew |
| Windows | `vim.vim` | winget |
| Windows | `vim` | Chocolatey |

## Development Dependencies

For contributing to this project:

| Tool | Purpose | Install |
|------|---------|---------|
| shellcheck | Bash linting | `apt install shellcheck` |
| git | Version control | Pre-installed |

## Version Compatibility Matrix

| OS | Minimum Version | Tested On |
|----|-----------------|-----------|
| Ubuntu | 20.04 | 22.04 |
| Fedora | 38 | 39 |
| macOS | 12 (Monterey) | Latest |
| Windows | 10 (1903) | 11 |

## Notes

- All shell scripts require Bash 4.0+ for associative arrays and other features
- Docker is optional for local testing but required for full CI coverage
- Windows scripts require PowerShell 5.1+ (pre-installed on Windows 10/11)
- Administrator/sudo privileges required for package installation
