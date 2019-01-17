#!/bin/sh

if ! test -w /etc/gai.conf ; then
	echo "We need write permission to /etc/gai.conf"
	return
fi

prefix=$(nslookup outlook.office365.com \
		 | sed -nE 's/^Address:[[:space:]]+(([[:alnum:]]+:){2}).+/\1/p' \
		 | head -1)
if test -z "$prefix" ; then
	echo 'IPv6 hadn'"'"' been resolved, fall back to default'
	prefix="2603:1046:"
fi

TEXT=$(printf 'precedence %s:/96 100\n' "$prefix")
if ! grep -qF "${TEXT}" /etc/gai.conf ; then
	echo "$TEXT" >> /etc/gai.conf
fi
