fpath=( ~/.config/zsh/functions ${fpath} )
fpath=( ~/.config/zsh/completions ${fpath} )

typeset -aU ffiles
ffiles=(~/.config/zsh/functions/**/[^_]*[^(~|.zwc)](N.:t))
(( ${#ffiles} > 0 )) && autoload -U "${ffiles[@]}"
unset -v ffiles

typeset -U fpath FPATH

if alias run-help &>/dev/null; then
	unalias run-help
fi
autoload -U run-help
