#!/bin/sh
#
#   This file echoes a bunch of color codes to the
#   terminal to demonstrate what's available.  Each
#   line is the color code of one foreground color,
#   out of 17 (default + 16 escapes), followed by a
#   test use of that color on all nine background
#   colors (default + 8 escapes).
#
#   Adapted from: http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

T='gYw'   # The test text

# The second line isn't an indentation
printf "\\n                         40m     41m     42m\
     43m     44m     45m     46m     47m\\n";

for FGs in 'Default    0m' 'Default    1m' \
	   'Black   0;30m' 'D Gray  1;30m' \
	   'Blue    0;34m' 'L Blue  1;34m' \
	   'Green   0;32m' 'L Green 1;32m' \
	   'Cyan    0;36m' 'L Cyan  1;36m' \
	   'Red     0;31m' 'L Red   1;31m' \
	   'Purple  0;35m' 'LPurple 1;35m' \
	   'Brown   0;33m' 'Yellow  1;33m' \
	   'L Gray  0;37m' 'White   1;37m'; do
	FG=$(echo "$FGs" | sed 's/.* //')
	printf ' %s \033[%s  %s  ' "$FGs" "$FG" $T
	for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
		printf '%s \033[%s\033[%s  %s  \033[0m' "$EINS" "$FG" "$BG" $T
	done
	echo;
done
echo
