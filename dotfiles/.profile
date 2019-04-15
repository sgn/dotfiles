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
unset DOTFILES_HOME

## Remove less history.
LESS='-RF'
LESSHISTFILE='-'
export LESS LESSHISTFILE

## Manpage.
MANPAGER="less -s"
MANWIDTH=80
export MANPAGER MANWIDTH

## Time display (with ls command for example).  GNU 'ls' only.
TIME_STYLE=long-iso
export TIME_STYLE

## SSH-Agent
. "${HOME}/.config/sh/load-ssh-agent.sh"
load_ssh_agent

## Default text editor
for i in vim vi; do
	command -v $i >/dev/null 2>&1 \
		&& EDITOR=$i && export EDITOR \
		&& break
done

## $HOME software install
## See http://nullprogram.com/blog/2017/06/19/.
add_to_path "$HOME/.local/bin" begin
add_to_path "$HOME/.local/include" begin C_INCLUDE_PATH
add_to_path "$HOME/.local/include" begin CXX_INCLUDE_PATH
add_to_path "$HOME/.local/lib" begin LIBRARY_PATH
add_to_path "$HOME/.local/lib/pkgconfig" begin PKG_CONFIG_PATH
add_to_path "$HOME/.local/share/info" begin INFOPATH
add_to_path "$HOME/.local/share/man" begin MANPATH

if command -v ruby >/dev/null 2>&1; then
	GEM_HOME=$(ruby -e 'print Gem.user_dir')
	export GEM_HOME
	add_to_path "$GEM_HOME/bin"
fi

ulimit -c unlimited

## Specific to local computer. Should be sourced last
[ -f "${XDG_CONFIG_HOME}/sh/lprofile" ] && . "${XDG_CONFIG_HOME}/sh/lprofile"

if test -z "$DISPLAY" && test "$(tty)" = '/dev/tty1' \
		&& command -v xinit >/dev/null 2>&1 ; then
	if test -z "$DBUS_SESSION_BUS_ADDRESS" \
			&& command -v dbus-run-session >/dev/null 2>&1; then
		exec dbus-run-session -- xinit -- vt01
	fi
	exec xinit -- vt01
fi
