# GPLv2 code from grml
# Create Directory and \kbd{cd} to it
mkcd () {
	if (( ARGC != 1 )); then
		printf 'usage: mkcd <new-directory>\n'
		return 1;
	fi
	command mkdir -p "$1"
	builtin cd "$1"
}

# Create temporary directory and \kbd{cd} to it
cdt () {
	builtin cd "$(mktemp -d)"
	builtin pwd
}

# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
accessed () {
	emulate -L zsh
	print -l -- *(a-${1:-1})
}

# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
changed () {
	emulate -L zsh
	print -l -- *(c-${1:-1})
}

# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
modified () {
	emulate -L zsh
	print -l -- *(m-${1:-1})
}
