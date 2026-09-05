#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_DIR="$THEME_DIR/wallpapers"

echo "==> Setting up Malazan-inspired theme..."

# Create wallpaper directory
mkdir -p "$WALLPAPER_DIR"

# Generate Malazan-themed wallpapers using ImageMagick if available
if command -v convert &> /dev/null; then
    echo "==> Generating Malazan-themed wallpapers..."
    
    # Malazan color palette: deep blacks, jade green, twilight blue, crimson
    # Azath-inspired: dark with subtle glowing patterns
    convert -size 1920x1080 \
        gradient:'#0a0a0f-#1a1a2e' \
        -sparse-color Barycentric '0,0 #0a0a0f 1920,1080 #1a1a2e' \
        -fill 'rgba(0,188,212,0.1)' -draw 'circle 960,540 960,400' \
        -fill 'rgba(0,188,212,0.05)' -draw 'circle 200,200 200,100' \
        -fill 'rgba(0,188,212,0.05)' -draw 'circle 1720,880 1720,780' \
        -blur 0x20 \
        "$WALLPAPER_DIR/malazan-azath.jpg"
    
    # Crimson-inspired (Rise of the Crimson Guard)
    convert -size 1920x1080 \
        gradient:'#0f0505-#1a0a0a' \
        -sparse-color Barycentric '0,0 #0f0505 1920,1080 #1a0a0a' \
        -fill 'rgba(200,50,50,0.08)' -draw 'circle 1500,300 1500,150' \
        -fill 'rgba(200,50,50,0.04)' -draw 'circle 400,800 400,650' \
        -blur 0x25 \
        "$WALLPAPER_DIR/malazan-crimson.jpg"
    
    # Tiste Andii-inspired (dark, ethereal)
    convert -size 1920x1080 \
        gradient:'#050510-#0a0a1a' \
        -sparse-color Barycentric '0,0 #050510 1920,1080 #0a0a1a' \
        -fill 'rgba(100,100,180,0.06)' -draw 'circle 300,600 300,450' \
        -fill 'rgba(150,100,200,0.04)' -draw 'circle 1600,400 1600,250' \
        -blur 0x30 \
        "$WALLPAPER_DIR/malazan-tiste.jpg"
    
    echo "==> Generated 3 Malazan-themed wallpapers"
else
    echo "==> ImageMagick not found. Creating placeholder wallpapers..."
    # Create solid color wallpapers as fallback
    for color in "#0a0a0f" "#0f0505" "#050510"; do
        name=$(echo "$color" | tr -d '"' | tr '#' '-')
        convert -size 1920x1080 xc:"$color" "$WALLPAPER_DIR/malazan${name}.jpg" 2>/dev/null || \
            echo "Warning: Could not create wallpaper for $color"
    done
fi

# Copy theme files to system locations
echo "==> Installing theme files..."
sudo mkdir -p /usr/share/color-schemes
sudo mkdir -p /usr/share/Kvantum
sudo mkdir -p /usr/share/plasma/look-and-feel
sudo mkdir -p /usr/share/wallpapers

sudo cp "$THEME_DIR/colorschemes/MalazanDark.colors" /usr/share/color-schemes/
sudo cp "$THEME_DIR/Kvantum/MalazanDark.kvconfig" /usr/share/Kvantum/
sudo cp -r "$THEME_DIR/plasma-look-and-feel/MalazanDark" /usr/share/plasma/look-and-feel/
sudo cp "$WALLPAPER_DIR"/*.jpg /usr/share/wallpapers/ 2>/dev/null || true

echo "==> Malazan theme installed!"
echo "==> Wallpapers available in: $WALLPAPER_DIR"
echo ""
echo "To apply the theme:"
echo "  1. System Settings → Appearance → Global Theme → Malazan Dark"
echo "  2. System Settings → Appearance → Colors → MalazanDark"
echo "  3. System Settings → Appearance → Kvantum → MalazanDark"
echo "  4. Right-click desktop → Configure Desktop → Wallpaper"
