# fd

Simple, fast, and user-friendly alternative to find.

## Technology

- **Tool**: fd (fd-find)
- **Category**: CLI Utilities
- **Language**: Rust
- **Purpose**: Fast file searching with intuitive syntax

## Installation Method

1. Attempts installation via apt-get (Debian/Ubuntu - as fd-find)
2. Falls back to dnf (Fedora/RHEL)
3. Falls back to yum (older RHEL/CentOS)
4. Falls back to pacman (Arch Linux)

## Notes

On Debian/Ubuntu, the command is `fdfind` due to a name conflict. Create an alias: `alias fd=fdfind`

## Links

- [GitHub Repository](https://github.com/sharkdp/fd)
