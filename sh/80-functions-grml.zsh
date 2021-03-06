# This block of code is licensed under the GPL v2
# Authors: grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
#
# Create Directory and cd to it
mkcd () {
	if (( ARGC != 1 )); then
		printf 'usage: mkcd <new-directory>\n'
		return 1;
	fi
	command mkdir -p "$1"
	builtin cd "$1"
}

# Create temporary directory and cd to it
cdt () {
	builtin cd "$(mktemp -d)"
	builtin pwd
}

# List files which have been accessed within the last ${1:-1} days
accessed () {
	emulate -L zsh
	print -l -- *(a-${1:-1})
}

# List files which have been changed within the last ${1:-1} days
changed () {
	emulate -L zsh
	print -l -- *(c-${1:-1})
}

# List files which have been modified within the last ${1:-1} days
modified () {
	emulate -L zsh
	print -l -- *(m-${1:-1})
}
# End of GPL v2 code from grml project
