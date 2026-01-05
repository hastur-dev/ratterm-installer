# mkcert

Simple tool for making locally-trusted development certificates.

## Technology

- **Tool**: mkcert
- **Category**: Security
- **Language**: Go
- **Purpose**: Create valid HTTPS certificates for local development

## Installation Method

1. Attempts installation via apt-get with libnss3-tools (Debian/Ubuntu)
2. Falls back to dnf with nss-tools (Fedora/RHEL)
3. Falls back to pacman (Arch Linux)
4. Falls back to GitHub releases binary download

## Notes

Run `mkcert -install` after installation to install the local CA.

## Links

- [GitHub Repository](https://github.com/FiloSottile/mkcert)
