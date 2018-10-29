#!/bin/sh
## This file should be automatically sourced by the login manager or Bash if
## .bash_profile does not exist.  If this file is not automatically sourced,
## do it from the shell config to me sure it applies to TTY as well.

## Mask
## Result for 027 is "rwxr-x---".  022 is the popular default.
##
## As a result applications make the bad assumption # that "others" have access.
## Another drawback of 027 is that is behaves badly with default sudo config: for
## instance "sudo mkdir foo" will effectively create a "foo" folder whose owner
## is root and with permission 027, even if root's umask is 022.  This is
## usually very bad.
## See https://wiki.archlinux.org/index.php/Sudo#Permissive_umask.
##
## It is possible to override sudo's umask by adding the following to the
## sudoers file:
##
## Defaults umask = 0022
## Defaults umask_override
#umask 027

## assumptions) you should always append entries to PATH, not prepend them.
## Usage: add_to_path <path> [prepend|append] [var]
add_to_path () {
	test -d "$1" || return
	test $# -eq 3 && PATHVAR="$3" || PATHVAR=PATH
	eval echo \$$PATHVAR | grep -q "\\(:\\|^\\)$1\\(:\\|$\\)" && return
	test $# -eq 1 && via=a || via="$2"
	case "$via" in
	p|pre|prepend|b|begin|f|first)
		eval $PATHVAR="$1:\$$PATHVAR"
		;;
	a|app|append|post|e|end|l|last)
		eval $PATHVAR="\$$PATHVAR:$1"
		;;
	*)
		echo "Invalid call to add_to_path"
		;;
	esac
	eval export $PATHVAR
}

## Last PATH entries.
add_to_path "${HOME}/.local/bin"
## Jailed application come here
add_to_path "${HOME}/.local/sbin" begin
add_to_path "${HOME}/.local/platform-tools"

## Remove less history.
LESSHISTFILE='-'
export LESSHISTFILE

## Manpage.
MANPAGER="less -s"
MANWIDTH=80
export MANPAGER MANWIDTH

## Time display (with ls command for example).  GNU 'ls' only.
TIME_STYLE=+"|%Y-%m-%d %H:%M:%S|"
export TIME_STYLE

## SSH-Agent
## Set SSH to use gpg-agent
unset SSH_AGENT_PID
if test "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ; then
	SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	export SSH_AUTH_SOCK
fi
# Set GPG TTY
GPG_TTY=$(tty)
export GPG_TTY
# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

## Linux specific
if test "$(uname -o)" = "GNU/Linux" ; then
	## Startup error log.
	## dmesg
	dmesg_err=$(dmesg | grep -i error | tee ~/dmesg.err.log | wc -l)
	test "$dmesg_err" -eq 0 && rm ~/dmesg.err.log 2>/dev/null
	## systemd
	count="$(systemctl show | awk -F= '$1=="NFailedUnits" {print $2; exit}')"
	if test "$count" -ne 0 ; then
		systemctl -l --failed > "$HOME/systemd.err.log"
	else
		rm -f ~/systemd.err.log
	fi

	## Set sound volume.  (Useless when running Pulseaudio.)
	# amixer 2>/dev/null | grep -q PCM && amixer set PCM 100%
fi

## Wine DLL overrides.
## Remove the annoying messages for Mono and Gecko.
export WINEDLLOVERRIDES="mscoree,mshtml="
## Do not create desktop links or start menu entries.
export WINEDLLOVERRIDES="$WINEDLLOVERRIDES;winemenubuilder.exe=d"

## Default text editor
## 'em' is a custom wrapper for emacsclient. See '.local/bin/em'.
## VISUAL is given priority by some programs like Mutt. This way we can separate
## editors that wait from those that don't.
for i in emc emacsclient emacs vim vi nano; do
	command -v $i >/dev/null 2>&1 \
		&& EDITOR=$i && export EDITOR \
		&& break
done
GIT_EDITOR="$EDITOR"
VISUAL="$EDITOR"
export GIT_EDITOR
export VISUAL

## $HOME software install
## See http://nullprogram.com/blog/2017/06/19/.
## The variables should not contain paths to non-existing folders as it may
## break compilers.
add_to_path "$HOME/.local/include" begin C_INCLUDE_PATH
add_to_path "$HOME/.local/include" begin CXX_INCLUDE_PATH
add_to_path "$HOME/.local/lib" begin LIBRARY_PATH
add_to_path "$HOME/.local/lib/pkgconfig" begin PKG_CONFIG_PATH
add_to_path "$HOME/.local/share/info" begin INFOPATH
add_to_path "$HOME/.local/share/man" begin MANPATH
## If you install a library in your home directory that is also installed on the
## system, and then run a system program, it may be linked against your library
## rather than the library installed on the system as was originally
## intended. This could have detrimental effects.
# export LD_LIBRARY_PATH=$HOME/.local/lib

if command -v ruby >/dev/null 2>&1; then
	GEM_HOME=$(ruby -e 'print Gem.user_dir')
	export GEM_HOME
	add_to_path "$GEM_HOME/bin"
fi

_JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_AWT_WM_NONREPARENTING

## Specific to local computer. Should be sourced last
[ -f ~/.profile_local ] && . ~/.profile_local
