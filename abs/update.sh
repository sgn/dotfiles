#!/bin/bash

pkgup () {
	cd $1
	test ! -f PKGBUILD && echo "$(pwd) doesn't have PKGBUILD" && exit
	source PKGBUILD
	if test ! -d "$pkgname" ||
			test "$(git -C "$pkgname" ls-remote origin HEAD | cut -f1)" \
			     != "$(git -C "$pkgname" rev-parse HEAD)" ; then
		makepkg -sfCci
	else
		echo "$pkgname is up-to-date"
	fi
}

CDPATH=
export CDPATH
BASEDIR=$(dirname "$0")
cd "$BASEDIR"

for pkg in ./*/ ; do
	test -d "$pkg" && (pkgup "$pkg")
done
