#!/bin/sh

ssoma sync --cron || exit 1
mbsync -a >/dev/null || exit 1
notmuch new 2>&1 | grep -vF 'non-mail' || exit 0
