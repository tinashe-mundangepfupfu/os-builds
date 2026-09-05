#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Rust userland tools..."

# Install Rust tools via cargo
if ! command -v cargo &> /dev/null; then
    echo "==> Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# File/search tools
cargo install ripgrep fd-find bat eza zoxide sd dust

# System monitoring
cargo install procs btop bottom tokei hyperfine bandwhich

# Terminal/shell
cargo install starship zellij yazi

# Editor
cargo install helix

echo "==> Rust tools installation complete!"
