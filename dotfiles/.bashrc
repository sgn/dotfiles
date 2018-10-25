#!/bin/bash
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if test -f /usr/share/git/git-prompt.sh; then
	source /usr/share/git/git-prompt.sh
fi

__my_command_prompt () {
	local my_usr_host='\033[0;32m\u\033[0;37m@\033[0;32m\h'
	local my_pwd='\033[0;36m\W'
	local my_time='\033[0;34m\A'
	local my_git_ps1='\033[0;32m$(__git_ps1 "(%s)")\033[0m'
	# TODO: add color to \$, somehow it's broken
	local my_prompt='\$ '
	PS1="$my_usr_host $my_pwd $my_time $my_git_ps1\\n$my_prompt"
}
__my_command_prompt

alias ll='ls -ahl'
alias ls='ls --color=auto'
alias xclipboard='xclip -selection clipboard'
alias mu-index='mu index --maildir=~/.cache/maildir'

fortune -a | \
	$(shuf -n 1 -e cowsay cowthink) \
		-$(shuf -n 1 -e b d g p s t w y) \
		-f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -W66

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
