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
mkdir -p ~/.cache/mpd/playlists

stow dotfiles -t ~
