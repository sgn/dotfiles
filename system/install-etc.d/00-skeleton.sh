#!/bin/sh

. "${0%/*}/common.sh"
cd "${0%/*}/../etc"

find . -type f -o -type l | while IFS= read -r name; do
	xcpdiff "$name"
done
