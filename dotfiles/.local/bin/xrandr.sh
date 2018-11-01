#!/bin/sh

direction="right-of above left-of"

all_disp=$(xrandr | sed -nE 's/(([[:alnum:]]+) (dis)?connected).*/\1/p' | tr '\n' ' ')

cmd="xrandr"
disp1=""

display_off () {
	cmd="$cmd --output $1 --off"
}

display_on () {
	disp="$1"
	if test -z "$disp1" ; then
		disp1="$disp"
		cmd="$cmd --output $disp --auto"
	else
		coord="${direction%% *}"
		direction="${direction#$coord?}"
		cmd="$cmd --output $disp --auto --$coord $disp1"
	fi
}

while test -n "$all_disp" ; do
	disp="${all_disp%% *}"
	all_disp="${all_disp#$disp?}"
	connected="${all_disp%% *}"
	all_disp="${all_disp#$connected?}"
	if test "$connected" = "connected" ; then
		display_on "$disp"
	else
		display_off "$disp"
	fi
done

#echo "$cmd"
eval "$cmd"
