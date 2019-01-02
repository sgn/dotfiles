#!/bin/sh

if ps -Cmbsync >/dev/null 2>&1; then
	echo "Another mbsync is running!" >&2
	exit 1
fi

mbsync -a >/dev/null || exit 1
notmuch new 2>&1 | grep -vF 'non-mail' || exit 0
