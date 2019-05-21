bindkey -v

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
bindkey . rationalise-dot
## without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

bindkey '\eq' push-line-or-edit
