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
alias dir="command ls -lSrah"
# Only show dot-directories
alias lad='command ls -d .*(/)'
# Only show dot-files
alias lsa='command ls -a .*(.)'
# Only files with setgid/setuid/sticky flag
alias lss='command ls -l *(s,S,t)'
# Only show symlinks
alias lsl='command ls -l *(@)'
# Display only executables
alias lsx='command ls -l *(*)'
# Display world-{readable,writable,executable} files
alias lsw='command ls -ld *(R,W,X.^ND/)'
# Display the ten biggest files
alias lsbig="command ls -flh *(.OL[1,10])"
# Only show directories
alias lsd='command ls -d *(/)'
# Only show empty directories
alias lse='command ls -d *(/^F)'
# Display the ten newest files
alias lsnew="command ls -rtlh *(D.om[1,10])"
# Display the ten oldest files
alias lsold="command ls -rtlh *(D.Om[1,10])"
# Display the ten smallest files
alias lssmall="command ls -Srl *(.oL[1,10])"
# Display the ten newest directories and ten newest .directories
alias lsnewdir="command ls -rthdl *(/om[1,10]) .*(D/om[1,10])"
# Display the ten oldest directories and ten oldest .directories
alias lsolddir="command ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])"

# use colors when GNU grep with color-support
if test -n "$grep_options"; then
	alias grep='grep '$grep_options
	alias egrep='egrep '$grep_options
	alias fgrep='fgrep '$grep_options
	unset grep_options
fi

# Remove current empty directory.
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'
