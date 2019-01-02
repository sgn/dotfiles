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
XDG_CONFIG_HOME		DEFAULT="${XDG_CONFIG_HOME_}"
EOF

cat <<EOF >| ~/.Xresources
#include "${XDG_CONFIG_HOME_}/Xresources/color.Xresources"
#include "${XDG_CONFIG_HOME_}/Xresources/urxvt.conf"
EOF

stow dotfiles -t ~
