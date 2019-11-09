#!/bin/bash

[ -f /etc/default/refind-kernel-hook.conf ] || exit 0

. /etc/default/refind-kernel-hook.conf

REFIND_CONF="${REFIND_CONF:-/boot/EFI/refind/refind.conf}"

zrefind_dir="${REFIND_CONF%/*}"

[ -d "$zrefind_dir" ] || exit 1

zefi_mountpoint=$(df -P "$REFIND_CONF" | awk 'NR==2{print $6}')
zicon="${zrefind_dir#$zefi_mountpoint}/icons/os_void.png"

cat <<-EOF
timeout 5
scanfor manual
EOF

kernels=( /boot/vmlinuz-* )
for ((i=${#kernels[@]}-1; i >= 0; i--)); do
	kernel="${kernels[$i]#/boot}"
	ver_rev="${kernel#/vmlinuz-}"
	initrd="/initramfs-${ver_rev}.img"
	cat <<EOF
menuentry "Void Linux ${ver_rev}" {
	icon     $zicon
	volume   "Void Linux"
	loader   ${kernel}
	initrd   ${initrd}
	options  "quiet"
}
EOF
done
