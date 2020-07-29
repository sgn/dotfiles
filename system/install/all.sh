#!/bin/sh

for f in "${0%/*}"/??-*.sh; do
	 test -x "$f" && "$f"
done
