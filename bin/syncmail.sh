#!/bin/sh

ping -q -c 1 imap.gmail.com >/dev/null 2>&1 || exit

PASSWORD_STORE_DIR="${HOME}/.cache/opass"
export PASSWORD_STORE_DIR
pass xxx >/dev/null 2>&1 || exit

if ps -Cmbsync >/dev/null 2>&1; then
	echo "Another mbsync is running!" >&2
	exit 1
fi

mbsync -aq || exit 1
notmuch new --quiet 2>&1
