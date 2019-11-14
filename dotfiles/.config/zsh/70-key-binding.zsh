bindkey -v

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
bindkey "\e[A" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search
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

# add a command line to the shells history without executing it
commit-to-history () {
	print -s ${(z)BUFFER}
	zle send-break
}
zle -N commit-to-history
bindkey -M viins "^x^h" commit-to-history

bindkey '\eq' push-line-or-edit
