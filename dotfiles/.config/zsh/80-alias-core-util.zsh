# dircolors
command -v dircolors &>/dev/null && eval $(dircolors -b)

case "$(uname -s)" in
Darwin|FreeBSD)
	export CLICOLOR=1
	ls_options="-G"
	grep_options="--color=auto"
	;;
Linux)
	ls_options="--group-directories-first --color=auto -v"
	grep_options="--color=auto"
	;;
esac

if test -n "$ls_options"; then
	alias ls="command ls $ls_options"
	alias la="command ls -la $ls_options"
	alias ll="command ls -l $ls_options"
	alias lh="command ls -hAl $ls_options"
	alias l="command ls -l $ls_options"
	unset ls_options
fi

# use colors when GNU grep with color-support
if test -n "$grep_options"; then
	alias grep='grep '$grep_options
	alias egrep='egrep '$grep_options
	alias fgrep='fgrep '$grep_options
	unset grep_options
fi

# Remove current empty directory.
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'
alias dir='command ls -lSrah'
