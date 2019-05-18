command -v dircolors >/dev/null 2>&1 && eval $(dircolors -b)

if [ Darwin = $UNAME_KERNEL ] || [ FreeBSD = $UNAME_KERNEL ]; then
	export CLICOLOR=1
fi
