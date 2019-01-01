#!/bin/sh
set -e
CDPATH=
export CDPATH
BASEDIR=$(readlink -f "$0")
BASEDIR="${BASEDIR%/*}"
cd "$BASEDIR"

git submodule update --init

mkdir -p ~/.gnupg
chmod go-rwx ~/.gnupg

XDG_CONFIG_HOME_="${BASEDIR}/config"

cat <<EOF >| ~/.pam_environment
DOTFILES_HOME		DEFAULT="${BASEDIR}"
XDG_CONFIG_HOME		DEFAULT="${XDG_CONFIG_HOME_}"
SSH_AUTH_SOCK		DEFAULT="\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
EOF

cat <<EOF >| ~/.Xresources
#include "${XDG_CONFIG_HOME_}/Xresources/color.conf"
#include "${XDG_CONFIG_HOME_}/Xresources/urxvt.conf"
EOF

stow dotfiles -t ~
