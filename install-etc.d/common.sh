die() {
	printf >&2 "%s\n" "$*"
	exit 1
}

xcpdiff() {
	if ! cmp -s "$1" "$DESTDIR/etc/$1"
	then
		mkdir -p "$DESTDIR/etc/${1%/*}"
		cp "$1" "$DESTDIR/etc/$1"
	fi
}

xlink() {
	[ -h "$2" ] || [ -f "$2" ] && rm "$2"
	if [ -d "$2" ]; then
		rmdir "$2" || exit 1
	fi
	ln -s "$1" "$2"
}
