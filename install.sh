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

cat <<EOF >| ~/.pam_environment
DOTFILES_HOME		DEFAULT="${BASEDIR}"
XDG_CONFIG_HOME		DEFAULT="${BASEDIR}/config"
SSH_AUTH_SOCK		DEFAULT="\${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
EOF

stow dotfiles -t ~
