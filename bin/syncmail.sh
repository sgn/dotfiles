#!/bin/sh

ping -q -c 1 imap.gmail.com >/dev/null 2>&1 || exit

PASSWORD_STORE_DIR="${HOME}/.cache/opass"
export PASSWORD_STORE_DIR
pass xxx >/dev/null 2>&1 || exit

LOCK_FILE=/tmp/syncmail.$(id -u).$(hostname).lock
(
if ! flock -n 3; then
	echo Sync mail is running 2>&1
	exit
fi
mbsync -aq
notmuch new --quiet
) 3>"$LOCK_FILE"
