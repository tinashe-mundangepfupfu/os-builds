# Malazan Dark Theme

A KDE Plasma 6 theme inspired by the atmospheric, brooding world of the Malazan Book of the Fallen series.

## Colors

- **Azath**: Deep cosmic black with subtle cyan accents
- **Crimson Guard**: Dark red tones for alerts and highlights
- **Tiste Andii**: Ethereal dark blue-purple gradients
- **Elder Warrens**: Jade green accents for selections and focus

## Installation

```bash
# Install theme files
sudo ./setup-malazan-theme.sh

# Or manually:
sudo cp colorschemes/MalazanDark.colors /usr/share/color-schemes/
sudo cp Kvantum/MalazanDark.kvconfig /usr/share/Kvantum/
sudo cp -r plasma-look-and-feel/MalazanDark /usr/share/plasma/look-and-feel/
```

## Wallpapers

Generated wallpapers are stored in `wallpapers/`:
- `malazan-azath.jpg` - Cosmic dark with cyan glow
- `malazan-crimson.jpg` - Blood red tones
- `malazan-tiste.jpg` - Ethereal dark blue

To use custom Malazan artwork, replace files in `wallpapers/` before building.

## Applying the Theme

After installation:
1. System Settings → Appearance → Global Theme → **Malazan Dark**
2. System Settings → Appearance → Colors → **MalazanDark**
3. System Settings → Appearance → Kvantum → **MalazanDark**
4. Right-click desktop → Configure Desktop → Wallpaper → Choose Malazan wallpaper

## Components

- **Colorscheme**: `MalazanDark.colors` - Dark atmospheric palette
- **Kvantum**: `MalazanDark.kvconfig` - Translucent/blurred window decorations
- **Look-and-feel**: `MalazanDark/metadata.desktop` - Plasma integration
- **Wallpapers**: Generated gradients inspired by Malazan lore

## Credits

Theme inspired by Steven Erikson's Malazan Book of the Fallen series.
