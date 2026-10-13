#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="alphax"
iso_label="ALPHAX_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="AlphaX Linux <https://github.com/DCE-21k69/Base-AlphaX>"
iso_application="AlphaX Linux - Gaming Distro"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.grub')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/local/bin/alphax"]="0:0:755"
  ["/usr/local/bin/alphax-branding-apply"]="0:0:755"
  ["/usr/local/bin/codex-session"]="0:0:755"
  ["/usr/local/bin/alphax-firstrun.sh"]="0:0:755"
  ["/usr/local/bin/alphax-postinstall-cleanup.sh"]="0:0:755"
  ["/etc/skel/.config/codex/scripts/gamemode-toggle.sh"]="0:0:755"
  ["/etc/skel/.config/codex/scripts/toggle-layout.sh"]="0:0:755"
  ["/etc/skel/.config/codex/scripts/wallpaper-picker.sh"]="0:0:755"
  ["/etc/skel/.config/codex/scripts/wifi-menu.sh"]="0:0:755"
)
