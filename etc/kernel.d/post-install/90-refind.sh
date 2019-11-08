#!/bin/sh

[ -d /boot/EFI/BOOT ] || exit
TEMP=$(mktemp /tmp/refind.XXXXXXXX)

cat <<EOF >| "$TEMP"
timeout 5
scanfor manual
EOF

for kernel in /boot/vmlinuz-* ; do
	kernel="${kernel#/boot}"
	ver_rev="${kernel#/vmlinuz-}"
	initrd="/initramfs-${ver_rev}.img"
	ed "$TEMP" <<EOF
2
a
menuentry "Void Linux (${ver_rev})" {
	icon     /EFI/BOOT/icons/os_void.png
	volume   "Void Linux"
	loader   ${kernel}
	initrd   ${initrd}
	options  "quiet"
}
.
wq
EOF
done >/dev/null 2>&1

mv -f /boot/EFI/BOOT/refind.conf /boot/EFI/BOOT/refind.conf.bak &&
mv "$TEMP" /boot/EFI/BOOT/refind.conf
