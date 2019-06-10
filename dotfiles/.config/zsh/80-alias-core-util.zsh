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

# use colors when GNU grep with color-support
if (( $#grep_options > 0 )); then
	o=${grep_options}
	alias grep='grep '$o
	alias egrep='egrep '$o
	alias fgrep='fgrep '$o
	unset o
fi
