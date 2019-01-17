#!/bin/bash

NFILE=$1
OFILE=${NFILE%.new-*}

echo "Working on $NFILE"

echo "Showing the diff:"

if diff -u "$OFILE" "$NFILE"; then
	echo "Old and new are equal!"
	echo "Remove new file (Y/n)?"
	read yn
	if test "$yn" = "${yn#[Nn]}" ; then
		rm -f "$NFILE"
	fi
	exit 0
fi

while true ; do
	echo
	cat <<-EOF
	Action:
		(k)eep them as is
		Use (o)ld file, delete new
		Use (n)ew file, overwrite old
	EOF
	read action

	case ${action:0:1} in
	k|K)
		echo "save untouch filename in /tmp/xetc"
		echo "$NFILE" >> /tmp/xetc
		break
		;;
	o|O)
		rm -f "$NFILE"
		break
		;;
	n|N)
		mv -f "$NFILE" "$OFILE"
		break
		;;
	esac
done
