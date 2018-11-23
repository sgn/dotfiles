#!/bin/sh

ssoma sync --cron || exit 0
mbsync -a >/dev/null || exit 0
notmuch new 2>&1 >/dev/null | grep -vF 'non-mail'
