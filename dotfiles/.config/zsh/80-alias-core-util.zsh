typeset -ga ls_options
typeset -ga grep_options

if ls --group-directories-first / >/dev/null 2>&1; then
	ls_options+=( '--group-directories-first' )
fi

# below code is ripped shamelessly from grml project
# Colors on GNU ls(1)
if ls --color=auto / >/dev/null 2>&1; then
	ls_options+=( --color=auto )
	# Colors on FreeBSD and OSX ls(1)
elif ls -G / >/dev/null 2>&1; then
	ls_options+=( -G )
fi

# Natural sorting order on GNU ls(1)
# OSX and IllumOS have a -v option that is not natural sorting
if ls --version |& grep -q 'GNU' >/dev/null 2>&1 &&
	ls -v / >/dev/null 2>&1;
	then
		ls_options+=( -v )
fi

# Color on GNU and FreeBSD grep(1)
if grep --color=auto -q "a" <<< "a" >/dev/null 2>&1; then
	grep_options+=( --color=auto )
fi

ls_options=(${(@u)ls_options})
grep_options=(${(@u)grep_options})

if (( $#ls_options > 0 )); then
	o=${ls_options}
	alias ls="command ls $o"
	alias la="command ls -la $o"
	alias ll="command ls -l $o"
	alias lh="command ls -hAl $o"
	alias l="command ls -l $o"
	unset o
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
if (( $#grep_options > 0 )); then
	o=${grep_options}
	alias grep='grep '$o
	alias egrep='egrep '$o
	alias fgrep='fgrep '$o
	unset o
fi

# Remove current empty directory.
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'
