#!/usr/bin/env bash
# profiledef.sh - archdev profile configuration

iso_name="shellos"
iso_label="SHELLOS_$(date +%Y%m)"
iso_publisher="arch-dev-live <https://github.com/your-user/arch-dev-live>"
iso_application="Arch Dev Live - Openbox Development ISO"
iso_version="$(date +%Y.%m.%d)"

install_dir="arch"
buildmodes=('iso')

bootmodes=(
  'bios.syslinux'
  'uefi.grub'
)

arch="x86_64"
pacman_conf="pacman.conf"

# squashfs con compressione zstd, livello alto per bilanciare dimensione/velocità
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/10-liveuser"]="0:0:440"
  ["/root"]="0:0:750"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/etc/skel/.xprofile"]="1000:1000:644"
  ["/etc/skel/.gtkrc-2.0"]="1000:1000:644"
  ["/etc/skel/.config"]="1000:1000:750"
  ["/etc/skel/.config/openbox"]="1000:1000:750"
  ["/etc/skel/.config/openbox/autostart"]="1000:1000:755"
  ["/etc/skel/.config/openbox/rc.xml"]="1000:1000:644"
  ["/etc/skel/.local"]="1000:1000:750"
  ["/etc/skel/.local/share"]="1000:1000:750"
  ["/etc/skel/.local/share/themes"]="1000:1000:750"
  ["/etc/skel/.local/share/themes/ShellOS-Dark"]="1000:1000:750"
  ["/etc/skel/.local/share/themes/ShellOS-Dark/openbox-3"]="1000:1000:750"
  ["/etc/skel/.local/share/themes/ShellOS-Dark/openbox-3/themerc"]="1000:1000:644"
)
