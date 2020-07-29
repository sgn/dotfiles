#!/bin/sh

do_copy() {
	find "$@" \( -type f -o -type l \) -print |
	while IFS= read -r name; do
		xcpdiff "$name"
	done
}

. "${0%/*}/common.sh"
cd "${0%/*}/.."
do_copy etc \( -name sv -name zoneshot.d \) -prune -o
do_copy usr
