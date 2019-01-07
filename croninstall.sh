#!/bin/sh

test -z "${XDG_CONFIG_HOME}" && XDG_CONFIG_HOME="$HOME/.config"
make_cron () {
	crontab -l 2>/dev/null |
		sed '/ssoma/d;
			/local\/bin\/syncmail.sh/d;
			/dunst\/battery/d'
	# minute hour day_of_month month day_of_week command
	cat <<-EOF
	*/10	 *    *		   *	 *	     ssoma sync --cron
	*/2	 *    *		   *	 *	     ${DOTFILES_HOME}/bin/syncmail.sh
	*/5	 *    *		   *	 *	     ${XDG_CONFIG_HOME}/dunst/battery.sh
	EOF
}

make_cron | tee /dev/stderr | crontab -
