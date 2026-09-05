# Oponn — Personal Arch-Based Linux

Malazan-inspired, speed-optimized Arch Linux live ISO with KDE Plasma 6, Calamares installer, and Rust userland tools.

## Prerequisites

- **Arch Linux host** (or Arch-based distro)
- Sudo access
- ~15 GB free disk space

Install build dependencies:

```bash
sudo pacman -S archiso calamares squashfs-tools libisoburn mkinitcpio grub syslinux qemu imagemagick
```

## Build the ISO

```bash
cd /path/to/os-builds
make build-iso
```

Output ISO lands in `output/`.

## Boot / Install

### QEMU UEFI

```bash
qemu-system-x86_64 \
  -m 4G -smp 4 \
  -drive if=pflash,format=raw,readonly=yes,file=/usr/share/edk2/x64/code.fd \
  -drive if=pflash,format=raw,file=/usr/share/edk2/x64/vars.fd \
  -boot d -cdrom output/*.iso -enable-kvm -cpu host -serial stdio
```

### QEMU BIOS

```bash
make test-bios
```

### Real hardware

Write ISO to USB:

```bash
sudo dd if=output/*.iso of=/dev/sdX bs=4M status=progress && sync
```

Boot the USB and run Calamares.

## GPU Support

### NVIDIA

NVIDIA drivers are auto-detected during installation. If an NVIDIA GPU is present:
- `nvidia-dkms`, `nvidia-utils`, `nvidia-settings`, `nvidia-prime` are installed
- Kernel parameter `nvidia-drm.modeset=1` is added for Wayland support
- NVIDIA modules are added to `mkinitcpio.conf` and initramfs is regenerated

### AMD / Intel

Open-source Mesa/Vulkan drivers are preinstalled. No additional configuration needed.

## Post-install

The installer runs `scripts/post-install.sh`, which:
- Enables NetworkManager, Bluetooth, fstrim.timer, reflector.timer, cups, SDDM
- Applies Malazan Dark KDE theme
- Generates locale, sets timezone/UTC
- Installs `paru` and applies KDE compositor tuning (Vulkan + blur)
- Auto-detects and configures NVIDIA drivers if present

## Validate

```bash
# In installed system
dmesg | grep -i cachyos
cat /proc/cmdline
paru -Si some-aur-package
rg --version

# Verify NVIDIA
nvidia-smi
```

## Troubleshooting

- `mkarchiso: command not found` → Install `archiso`: `sudo pacman -S archiso`
- Build fails due to missing packages → Ensure all prerequisites are installed
- ISO won't boot in QEMU → Verify UEFI/BIOS settings, try `make test-bios`
- NVIDIA not detected → Ensure `lspci` shows NVIDIA GPU in live environment
