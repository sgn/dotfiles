#!/bin/sh

#umask 027

## Usage: add_to_path <path> [begin|end] [var]
add_to_path () {
	test -d "$1" || return
	test $# -eq 3 && PATHVAR="$3" || PATHVAR=PATH
	eval echo \$$PATHVAR | grep -q "\\(:\\|^\\)$1\\(:\\|$\\)" && return
	test $# -eq 1 && via=end || via="$2"
	case "$via" in
	begin)
		eval $PATHVAR="$1:\$$PATHVAR"
		;;
	end)
		eval $PATHVAR="\$$PATHVAR:$1"
		;;
	*)
		echo "Invalid call to add_to_path: $via"
		;;
	esac
	eval export $PATHVAR
	unset PATHVAR
}

TZ="Asia/Ho_Chi_Minh"
export TZ

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CONFIG_HOME

## My scripts come here
DOTFILES_HOME=$(readlink -f ~/.profile)
DOTFILES_HOME="${DOTFILES_HOME%/*/.profile}"
add_to_path "${DOTFILES_HOME}/bin" begin
add_to_path "${HOME}/.local/platform-tools"

## pager
PAGER='less'
export PAGER

## Remove less history.
LESS='-RXF'
LESSHISTFILE='-'
# support colors in less
xesc=$(printf '\033')
LESS_TERMCAP_mb="${xesc}[01;31m"
LESS_TERMCAP_md="${xesc}[01;31m"
LESS_TERMCAP_me="${xesc}[0m"
LESS_TERMCAP_se="${xesc}[0m"
LESS_TERMCAP_so="${xesc}[01;44;33m"
LESS_TERMCAP_ue="${xesc}[0m"
LESS_TERMCAP_us="${xesc}[01;32m"
unset xesc
export LESS LESSHISTFILE LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me \
	LESS_TERMCAP_se LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us

## Manpage.
MANPAGER="less -s"
MANWIDTH=80
export MANPAGER MANWIDTH

## Time display (with ls command for example).  GNU 'ls' only.
TIME_STYLE=long-iso
export TIME_STYLE

## system mailbox
MAIL=/var/mail/$USER
export MAIL

## SSH-Agent
if [ -r "${HOME}/.config/zsh/functions/load-ssh-agent" ]; then
	. "${HOME}/.config/zsh/functions/load-ssh-agent"
fi

## Default text editor
for i in ed ex vim vi; do
	command -v $i >/dev/null 2>&1 \
		&& EDITOR=$i && export EDITOR \
		&& break
done

for i in vim vi; do
	command -v $i >/dev/null 2>&1 \
		&& VISUAL=$i && export VISUAL \
		&& break
done

## $HOME software install
## See http://nullprogram.com/blog/2017/06/19/.
add_to_path "$HOME/.local/bin" begin
add_to_path "$HOME/bin" begin
add_to_path "$HOME/.local/include" begin C_INCLUDE_PATH
add_to_path "$HOME/.local/include" begin CXX_INCLUDE_PATH
add_to_path "$HOME/.local/lib" begin LIBRARY_PATH
add_to_path "$HOME/.local/lib/pkgconfig" begin PKG_CONFIG_PATH
add_to_path "$HOME/.local/share/info" begin INFOPATH
add_to_path "$HOME/.local/share/man" begin MANPATH

if [ -x "$HOME/workspace/git/git" ]; then
	PATH="$HOME/workspace/git:$PATH"
	GIT_EXEC_PATH="$HOME/workspace/git"
	export GIT_EXEC_PATH
fi

GEM_HOME="$HOME/.local/share/gem"
GEM_SPEC_CACHE="$HOME/.cache/gem"
export GEM_HOME GEM_SPEC_CACHE
add_to_path "$GEM_HOME/bin"

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LC_ALL

## Specific to local computer. Should be sourced last
[ -r "${HOME}/.config/sh/lprofile" ] && . "${HOME}/.config/sh/lprofile"
