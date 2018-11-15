#!/bin/sh

tmp=$(mktemp)
cat <<EOF >| $tmp
# minute hour day_of_month month day_of_week command
*/2	 *    *		   *	 *	     ${HOME}/.local/bin/syncmail.sh
*/5	 *    *		   *	 *	     ${HOME}/.config/dunst/battery.sh
EOF

EDITOR="mv -f ${tmp}" VISUAL="mv -f ${tmp}" crontab -e
