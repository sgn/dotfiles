if [ -f /usr/share/bash-completion/bash_completion ]; then
	source /usr/share/bash-completion/bash_completion
fi
if fzf --help | grep -q -e --bash; then
	source <(fzf --bash)
fi
