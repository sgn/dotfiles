#!/bin/sh
CDPATH=
export CDPATH
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
mkdir -p ~/.gnupg
chmod go-rwx ~/.gnupg
stow dotfiles -t ~
