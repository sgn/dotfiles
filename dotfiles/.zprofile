[ -f ~/.profile ] && source ~/.profile

ulimit -c unlimited

if test -z "$DISPLAY" && test "$(tty)" = '/dev/tty1' \
		&& command -v xinit >/dev/null 2>&1 ; then
	if test -z "$DBUS_SESSION_BUS_ADDRESS" \
			&& command -v dbus-run-session >/dev/null 2>&1; then
		exec dbus-run-session -- xinit -- vt01
	fi
	exec xinit -- vt01
fi
