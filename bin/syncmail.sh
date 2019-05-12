#!/bin/sh

ping -q -c 1 imap.gmail.com >/dev/null 2>&1 || exit

PASSWORD_STORE_DIR="${HOME}/.cache/opass"
export PASSWORD_STORE_DIR
pass xxx >/dev/null 2>&1 || exit

LOCK_FILE=/tmp/syncmail.$(id -u).$(hostname).lock
if test -f "$LOCK_FILE"; then
	echo Sync mail is running 2>&1
	exit
fi

touch "$LOCK_FILE"
mbsync -aq
notmuch new --quiet
rm "$LOCK_FILE"
