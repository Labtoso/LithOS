#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="lithos"
iso_label="LITHOS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="LabtosoStudios <https://lithos.labtoso.de>"
iso_application="LithOS Live"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="lithos"
bootmodes=('bios.syslinux'
           'uefi.grub')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
kernel_params_aarch64="clk_ignore_unused pd_ignore_unused arm64.nopauth"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/etc/sudoers.d/10-lithos-live"]="0:0:440"
  ["/usr/local/bin/lithos-firstlogin"]="0:0:755"
  ["/usr/local/bin/lithos-live-setup"]="0:0:755"
  ["/usr/local/bin/lithos-install"]="0:0:755"
  ["/usr/local/bin/lithos-postinstall"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/lib/lithos/lithos-hwsetup"]="0:0:755"
  ["/usr/lib/lithos/lithos-update-check"]="0:0:755"
  ["/usr/bin/lithos-update"]="0:0:755"
)
