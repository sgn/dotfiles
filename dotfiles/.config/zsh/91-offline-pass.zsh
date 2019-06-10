opass() {
	DISPLAY= PASSWORD_STORE_DIR="${HOME}/.cache/opass" pass "$@"
}

compdef _pass opass
zstyle ':completion::complete:opass::' prefix "$HOME/.cache/opass"
