#!/bin/bash
[[ $- != *i* ]] && return

if [ -f ~/.config/bash/bash.bashrc ]; then
	source ~/.config/bash/bash.bashrc
else
	for f in ~/.config/bash/*.bash; do
		source "$f"
	done; unset f
fi
