#!/bin/sh

cat <<EOF
timeout 5
scanfor manual
EOF

for kernel in /boot/vmlinuz-* ; do
	kernel="${kernel#/boot}"
	ver_rev="${kernel#/vmlinuz-}"
	initrd="/initramfs-${ver_rev}.img"
	cat <<EOF
menuentry "Void Linux (${ver_rev})" {
	icon     /EFI/refind/icons/os_void.png
	volume   b6ede7cb-4592-4fae-98ab-e761fa8dc081
	loader   ${kernel}
	initrd   ${initrd}
	options  "root=PARTUUID=79de8074-3b32-4408-9a56-70e8ace04e43 rw add_efi_memmap quiet"
}
EOF
done
