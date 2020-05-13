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
