if [ -f ~/.config/zsh/zsh.zshrc ]; then
	source ~/.config/zsh/zsh.zshrc
	source ~/.config/zsh/stolen.zshrc
else
	for f in ~/.config/zsh/*.zsh ~/.config/zsh/*.stolen; do
		source "$f"
	done
fi

zstyle ':vcs_info:*' enable git

## changed completer settings
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix

# Switching shell safely and efficiently?
# http://www.zsh.org/mla/workers/2001/msg02410.html
bash() {
    NO_SWITCH="yes" command bash "$@"
}

restart () {
    exec $SHELL $SHELL_ARGS "$@"
}

## Handy functions for use with the (e::) globbing qualifier (like nt)
contains() { grep -q "$*" $REPLY }
sameas() { diff -q "$*" $REPLY &>/dev/null }
ot () { [[ $REPLY -ot ${~1} ]] }
