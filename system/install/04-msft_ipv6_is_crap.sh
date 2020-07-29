#!/bin/sh

mkdir -p "$DESTDIR/etc" || die "Can't create '$DESTDIR/etc'"

prefix=$(nslookup outlook.office365.com \
		 | sed -nE 's/^Address:[[:space:]]+(([[:alnum:]]+:){2}).+/\1/p' \
		 | head -1)
if test -z "$prefix" ; then
	echo 'IPv6 hadn'"'"' been resolved, fall back to default'
	prefix="2603:1046:"
fi

TEXT=$(printf 'precedence %s:/96 100\n' "$prefix")
grep -qF "${TEXT}" "$DESTDIR/etc/gai.conf" 2>/dev/null ||
echo "$TEXT" >> "$DESTDIR/etc/gai.conf"
