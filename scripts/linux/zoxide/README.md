# zoxide

Smarter cd command that learns your habits.

## Technology

- **Tool**: zoxide
- **Category**: Navigation, Shell
- **Language**: Rust
- **Purpose**: Fast directory navigation with frecency-based ranking

## Installation Method

1. Attempts installation via apt-get (Debian/Ubuntu)
2. Falls back to dnf (Fedora/RHEL)
3. Falls back to pacman (Arch Linux)
4. Falls back to cargo install

## Configuration

Add to your shell config:
- Bash: `eval "$(zoxide init bash)"`
- Zsh: `eval "$(zoxide init zsh)"`
- Fish: `zoxide init fish | source`

## Links

- [GitHub Repository](https://github.com/ajeetdsouza/zoxide)
