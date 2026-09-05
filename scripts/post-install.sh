#!/usr/bin/env bash
set -euo pipefail

echo "==> Running post-install setup..."

# Set hostname
hostnamectl set-hostname oponn

# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Generate locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set console font
echo "KEYMAP=us" > /etc/vconsole.conf

# Enable essential services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable fstrim.timer
systemctl enable reflector.timer
systemctl enable cups
systemctl enable sddm

# Set CPU governor
echo "performance" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Configure reflector
cat > /etc/xdg/reflector/reflector.conf << 'REFLECTOR'
--save /etc/pacman.d/mirrorlist
--protocol https
--country "United States,Germany,France,United Kingdom"
--latest 5
--sort age
--age 6
--verbose
REFLECTOR

reflector --save /etc/pacman.d/mirrorlist --protocol https --country "United States,Germany,France" --latest 5 --sort age --age 6

# Update system
pacman -Syu --noconfirm

# Install paru
if ! command -v paru &> /dev/null; then
    sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    sudo -u "$SUDO_USER" makepkg -si --noconfirm
    cd -
    rm -rf /tmp/paru
fi

# Configure paru
sudo -u "$SUDO_USER" mkdir -p "/home/$SUDO_USER/.config/paru"
cat > "/home/$SUDO_USER/.config/paru/paru.conf" << 'PARU'
[options]
PacmanConf = /etc/pacman.conf
BuildDir = /home/$SUDO_USER/.cache/paru
DownloadDir = /home/$SUDO_USER/.cache/paru/clone
RemoveMake = yes
AnswerRewrite = None
ShowBuildOf = Ask
BatchInstall = yes
Needed = yes
PARU

# Detect and install NVIDIA drivers if present
if lspci | grep -qi nvidia; then
    echo "==> NVIDIA GPU detected, installing drivers..."
    
    # Install NVIDIA packages
    pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings nvidia-prime
    
    # Add NVIDIA kernel parameter
    if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 /' /etc/default/grub
    fi
    
    # Add NVIDIA modules to mkinitcpio
    if ! grep -q "nvidia" /etc/mkinitcpio.conf; then
        sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    fi
    
    # Regenerate initramfs
    mkinitcpio -P
    
    # Update GRUB
    grub-mkconfig -o /boot/grub/grub.cfg
    
    echo "==> NVIDIA drivers installed and configured"
else
    echo "==> No NVIDIA GPU detected, skipping NVIDIA driver installation"
fi

# Apply KDE settings
sudo -u "$SUDO_USER" mkdir -p "/home/$SUDO_USER/.config"
cat > "/home/$SUDO_USER/.config/kwinrc" << 'KWIN'
[Compositing]
Backend=Vulkan
LatencyPolicy=Low
RefreshRate=144

[Blur]
Blur=yes
BlurStrength=15

[Desktops]
Name_0=Desktop
Num_0=1

[Plugins]
kwin4_effect_maximize=1
kwin4_effect_tasks=1
kwin4_effect_translucency=1
kwin4_effect_fading=1
kwin4_effect_diminactive=1
kwin4_effect_coverswitch=1
kwin4_effect_cleanup=1
kwin4_effect_presentwindows=1
kwin4_effect_morphinglist=1
kwin4_effect_desktopgrid=1
KWIN

# Set up symlinks for Rust tools
sudo -u "$SUDO_USER" mkdir -p "/home/$SUDO_USER/.local/bin"
for tool in rg fd bat eza zoxide sd dust procs btop tokei hyperfine bandwhich yazi zellij; do
    if command -v "$tool" &> /dev/null; then
        ln -sf "$(which "$tool")" "/home/$SUDO_USER/.local/bin/$tool"
    fi
done

# Install Malazan theme
if [ -f "/usr/share/color-schemes/MalazanDark.colors" ]; then
    echo "==> Applying Malazan Dark theme..."
    lookandfeeltool -a org.kde.malazandark.desktop
fi

# Enable Plymouth
plymouth-set-default-theme -R arch-10
mkinitcpio -P

echo "==> Post-install setup complete!"
