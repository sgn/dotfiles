bindkey -v

### BEGIN GPLv2 code, (c) by grml team

# press "ctrl-x d" to insert the actual date in the form yyyy-mm-dd
insert-datestamp () { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp
bindkey -M viins '^xd' insert-datestamp

# press esc-m for inserting last typed word again (thanks to caphuso!)
insert-last-typed-word () { zle insert-last-word -- 0 -1 };
zle -N insert-last-typed-word;
bindkey -M viins "\em" insert-last-typed-word

# run command line as user root via sudo:
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

# Create directory under cursor or the selected area
mkdir-in-place () {
    # Press ctrl-xM to create the directory under the cursor or the selected area.
    # FIXME: To select an area press ctrl-@ or ctrl-space and use the cursor.
    # Use case: you type "mv abc ~/testa/testb/testc/" and remember that the
    # directory does not exist yet -> press ctrl-XM and problem solved
    local PATHTOMKDIR
    if ((REGION_ACTIVE==1)); then
        local F=$MARK T=$CURSOR
        if [[ $F -gt $T ]]; then
            F=${CURSOR}
            T=${MARK}
        fi
        # get marked area from buffer and eliminate whitespace
        PATHTOMKDIR=${BUFFER[F+1,T]%%[[:space:]]##}
        PATHTOMKDIR=${PATHTOMKDIR##[[:space:]]##}
    else
        local bufwords iword
        bufwords=(${(z)LBUFFER})
        iword=${#bufwords}
        bufwords=(${(z)BUFFER})
        PATHTOMKDIR="${(Q)bufwords[iword]}"
    fi
    [[ -z "${PATHTOMKDIR}" ]] && return 1
    PATHTOMKDIR=${~PATHTOMKDIR}
    if [[ -e "${PATHTOMKDIR}" ]]; then
        zle -M " path already exists, doing nothing"
    else
        zle -M "$(mkdir -p -v "${PATHTOMKDIR}")"
        zle end-of-line
    fi
}
zle -N mkdir-in-place
bindkey -M viins '^xM' mkdir-in-place

# add a command line to the shells history without executing it
function commit-to-history () {
    print -s ${(z)BUFFER}
    zle send-break
}
zle -N commit-to-history
bindkey -M viins "^x^h" commit-to-history

# only slash should be considered as a word separator:
function slash-backward-kill-word () {
    local WORDCHARS="${WORDCHARS:s@/@}"
    # zle backward-word
    zle backward-kill-word
}
zle -N slash-backward-kill-word
bindkey -M viins "\e^h" slash-backward-kill-word
bindkey -M viins "\e^?" slash-backward-kill-word
### END GPLv2 code, (c) by grml team

autoload insert-files
zle -N insert-files
bindkey -M viins "^xf" insert-files

autoload edit-command-line
zle -N edit-command-line
bindkey -M viins '\ee' edit-command-line
bindkey -M vicmd '\ee' edit-command-line

autoload insert-unicode-char
zle -N insert-unicode-char
bindkey -M viins '^xi' insert-unicode-char

# Do history expansion on space:
bindkey -M viins ' ' magic-space

bindkey -M viins '\ei' menu-complete
bindkey -M viins '^r' history-incremental-pattern-search-backward
bindkey -M vicmd '^r' history-incremental-pattern-search-backward
bindkey -M viins '^s' history-incremental-pattern-search-forward
bindkey -M vicmd '^s' history-incremental-pattern-search-forward

bindkey -M menuselect '+' accept-and-menu-complete
bindkey -M menuselect '^o' accept-and-infer-next-history

# https://wiki.archlinux.org/index.php/zsh#History_search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey -M vicmd k up-line-or-beginning-search
bindkey -M vicmd j down-line-or-beginning-search

## press ctrl-q to quote line:
mquote () {
     zle vi-beginning-of-line
     zle vi-forward-word
     # RBUFFER="'$RBUFFER'"
     RBUFFER=${(q)RBUFFER}
     zle end-of-line
}
zle -N mquote && bindkey '^Q' mquote

# just type '...' to get '../..'
rationalise-dot() {
local MATCH
if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
	LBUFFER+=/
	zle self-insert
	zle self-insert
else
	zle self-insert
fi
}
zle -N rationalise-dot
bindkey -M viins . rationalise-dot
## without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

bindkey '\eq' push-line-or-edit
