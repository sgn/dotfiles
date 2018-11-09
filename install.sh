#!/bin/sh
CDPATH=
export CDPATH
BASEDIR=$(dirname -- "$0")
cd "$BASEDIR"

git submodule update --init

mkdir -p ~/.gnupg
chmod go-rwx ~/.gnupg
stow dotfiles -t ~
