#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ISO_DIR="$PROJECT_ROOT/archiso"
OUTPUT_DIR="$PROJECT_ROOT/output"

echo "==> Building Oponn ISO..."
echo "==> Project root: $PROJECT_ROOT"
echo "==> ISO profile: $ISO_DIR"

# Check dependencies
if ! command -v mkarchiso &> /dev/null; then
    echo "ERROR: mkarchiso not found. Install archiso first:"
    echo "  sudo pacman -S archiso"
    exit 1
fi

if ! command -v sudo &> /dev/null; then
    echo "ERROR: sudo not found. This script requires sudo."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

cd "$ISO_DIR"

echo "==> Running mkarchiso..."
sudo mkarchiso -v -o "$OUTPUT_DIR" .

echo "==> ISO build complete!"
echo "==> Output directory: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR"
