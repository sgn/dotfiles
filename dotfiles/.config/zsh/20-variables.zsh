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

# dirstack
DIRSTACKSIZE=20
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
	[[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
	print -l $PWD ${(u)dirstack} >! $DIRSTACKFILE
}
