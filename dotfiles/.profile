#!/bin/sh

#umask 027

add_to_path () {
	if test $# -eq 1; then
		via=end
	else
		via="$1"
		shift
	fi
	test -d "$1" || return
	case ":$PATH:" in
		*:"$1":*) return ;;
		*) ;;
	esac
	case "$via" in
	begin)
		PATH=$1:$PATH
		;;
	end)
		PATH=$PATH:$1
		;;
	*)
		echo "Invalid call to add_to_path: $via" >&2
		;;
	esac
}

TZ="Asia/Ho_Chi_Minh"
export TZ

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CONFIG_HOME

## My scripts come here
DOTFILES_HOME=$(readlink -f ~/.profile)
DOTFILES_HOME="${DOTFILES_HOME%/*/.profile}"
add_to_path begin "${DOTFILES_HOME}/bin"
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
SSH_AUTH_SOCK="/run/user/$USER/ssh-$(uname -n).socket"
export SSH_AUTH_SOCK

## Default text editor
for i in ed ex vim vi; do
	command -v $i >/dev/null 2>&1 \
		&& EDITOR=$i && export EDITOR \
		&& break
done
unset i

for i in vim vi; do
	command -v $i >/dev/null 2>&1 \
		&& VISUAL=$i && export VISUAL \
		&& break
done
unset i

## $HOME software install
## See http://nullprogram.com/blog/2017/06/19/.
add_to_path begin "$HOME/.local/bin"
add_to_path begin "$HOME/bin"
add_to_path begin "$HOME/workspace/xtools"

if [ -x "$HOME/workspace/git/git" ]; then
	add_to_path begin "$HOME/workspace/git"
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

for socket in /var/lib/mpd/socket /tmp/mpd.socket; do
	if [ -S "$socket" ]; then
		MPD_HOST=$socket
		export MPD_HOST
		break;
	fi
done
unset socket

## Specific to local computer. Should be sourced last
. "${HOME}/.config/local.profile"
