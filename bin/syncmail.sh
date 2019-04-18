#!/bin/sh

if ps -Cmbsync >/dev/null 2>&1; then
	echo "Another mbsync is running!" >&2
	exit 1
fi

mbsync -aq || exit 1
notmuch new --quiet 2>&1 | grep -vF 'non-mail' || true
