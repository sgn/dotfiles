# vim: ft=bash
del_home_local_bin() {
	local lbin=":$HOME/.local/bin:"
	if test -z "$ZSH_VERSION"; then
		lbin="${lbin//\//\\/}"
	fi
	local epath=":$PATH:"
	epath="${epath//$lbin/:}"
	epath="${epath%:}"
	export PATH="${epath#:}"
}

add_home_local_bin() {
	case ":$PATH:" in
	*:$HOME/.local/bin:*) ;;
	*) PATH="$HOME/.local/bin:$PATH" ;;
	esac
}

build_flags() {
	CFLAGS+=" -fstack-protector-strong -D_FORTIFY_SOURCE=2 -march=native -mtune=native"
	LDFLAGS+=" -Wl,--as-needed -Wl,-z,relro -Wl,-z,now"
	export CFLAGS LDFLAGS
}
