# This block of code is licensed under the GPL v2
# Authors: grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
#
# "ctrl-x d" to insert the current date in yyyy-mm-dd
insert-datestamp () { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp
bindkey -M viins '^xd' insert-datestamp

# Alt-m for inserting last typed word again (thanks to caphuso!)
insert-last-typed-word () { zle insert-last-word -- 0 -1 };
zle -N insert-last-typed-word;
bindkey -M viins "\em" insert-last-typed-word

# Ctrl-O s to prefix command with sudo
sudo-command-line () {
	[[ -z $BUFFER ]] && zle up-history
	if [[ $BUFFER != sudo\ * ]]; then
		BUFFER="sudo $BUFFER"
		CURSOR=$(( CURSOR+5 ))
	fi
}
zle -N sudo-command-line
bindkey -M viins "^os" sudo-command-line

### jump behind the first word on the cmdline.
### useful to add options.
jump-after-first-word () {
	local words
	words=(${(z)BUFFER})

	if (( ${#words} <= 1 )) ; then
		CURSOR=${#BUFFER}
	else
		CURSOR=${#${words[1]}}
	fi
}
zle -N jump-after-first-word
bindkey -M viins '^x1' jump-after-first-word

# Ctrl-X M to create directory under cursor
mkdir-in-place () {
	local newdir bufwords iword
	bufwords=(${(z)LBUFFER})
	iword=${#bufwords}
	bufwords=(${(z)BUFFER})
	newdir="${(Q)bufwords[iword]}"
	[[ -z "${newdir}" ]] && return 1
	newdir=${~newdir}
	if [[ ! -e "${newdir}" ]]; then
		zle -M "$(mkdir -p -v "${newdir}")"
		zle end-of-line
	fi
}
zle -N mkdir-in-place
bindkey -M viins '^xM' mkdir-in-place

# Alt-BS to kill word until space/slash
# only slash should be considered as a word separator:
slash-backward-kill-word () {
	local WORDCHARS="${WORDCHARS:s@/@}"
	zle backward-kill-word
}
zle -N slash-backward-kill-word
bindkey -M viins "\e^?" slash-backward-kill-word
bindkey -M viins "\e^h" slash-backward-kill-word
# End of GPL v2 code from grml project
