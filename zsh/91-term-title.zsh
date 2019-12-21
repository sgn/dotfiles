set_term_title () {
	print -Pn "\e]0;$1\a"
}

# Reload autoloadable functions
function freload () {
	while (( $# )); do
		unfunction $1
		autoload -U $1
		shift
	done
}
compdef _functions freload
