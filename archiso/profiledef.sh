#!/usr/bin/env bash
# archiso profiledef.sh

iso_name="oponn"
iso_label="OPONN"
iso_publisher="Oponn Build"
iso_application="Personal Arch-based Linux"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
buildmodes=('iso')
pacstrap_conf=(/etc/pacman.conf)
makepkg_conf=(/etc/makepkg.conf)
locale_conf=(/etc/locale.gen)
passenv=('GNUPGHOME' 'BUILDDIR')
pacman_args=('--cachedir' '/var/cache/pacman/pkg')
compression="zstd"
compress_args=('-Xcompression-level' '9')
grub_cmdline_linux="quiet splash mitigations=off preempt=full rcu_nocbs=0-7"
grub_cmdline_linux_default="quiet splash mitigations=off preempt=full rcu_nocbs=0-7"
syslinux_cmdline_linux="quiet splash mitigations=off preempt=full rcu_nocbs=0-7"
syslinux_cmdline_linux_default="quiet splash mitigations=off preempt=full rcu_nocbs=0-7"
chmoddict=({etc,etc/pacman.d,etc/pacman.conf} 644 {etc/calamares} 755 {usr/bin} 755 {usr/share} 755)
