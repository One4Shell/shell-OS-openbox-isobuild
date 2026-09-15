#!/usr/bin/env bash
# profiledef.sh - archdev profile configuration

iso_name="archdev"
iso_label="ARCHDEV_$(date +%Y%m)"
iso_publisher="arch-dev-live <https://github.com/your-user/arch-dev-live>"
iso_application="Arch Dev Live - Openbox Development ISO"
iso_version="$(date +%Y.%m.%d)"

install_dir="arch"
buildmodes=('iso')

bootmodes=(
  'bios.syslinux.mbr'
  'bios.syslinux.eltorito'
  'uefi-ia32.grub.esp'
  'uefi-x64.grub.esp'
  'uefi-ia32.grub.eltorito'
  'uefi-x64.grub.eltorito'
)

arch="x86_64"
pacman_conf="pacman.conf"

# squashfs con compressione zstd, livello alto per bilanciare dimensione/velocità
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/etc/skel/.xprofile"]="1000:1000:644"
  ["/etc/skel/.config"]="1000:1000:750"
  ["/etc/skel/.config/openbox"]="1000:1000:750"
  ["/etc/skel/.config/openbox/autostart"]="1000:1000:755"
)
