# dircolors
command -v dircolors >/dev/null 2>&1 && eval $(dircolors -b)

if [ Darwin = "$UNAME_KERNEL" ] || [ FreeBSD = "$UNAME_KERNEL" ]; then
	export CLICOLOR=1
fi

# report
MAILCHECK=30
REPORTTIME=5
watch=(notme root)

# history
HISTFILE="$HOME/.cache/zsh/history"
HISTSIZE=5000
SAVEHIST=10000
