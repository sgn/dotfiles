opass() {
	DISPLAY= PASSWORD_STORE_DIR="${HOME}/.cache/opass" pass "$@"
}

pass-login () {
	local clip qrcode
	case $1 in
		show) shift;;
	esac
	while (( $# )); do
		case $1 in
		--clip*|-c*) clip=1; shift ;;
		--qr*|-q*) qrcode=1; shift ;;
		*) break ;;
		esac
	done
	login=$(pass show "$1" | sed -n '/^login: /s/login: //p')
	if [[ "$clip" ]]; then
		echo -n "$login" | clip
		echo "Login copied into clipboard"
	elif [[ "$qrcode" ]]; then
		echo -n "$login" | qrencode -t utf8
	else
		echo "$login"
	fi
}

compdef _pass opass
compdef _pass pass-login
zstyle ':completion::complete:opass::' prefix "$HOME/.cache/opass"
