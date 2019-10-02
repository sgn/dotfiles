#!/bin/bash
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

__my_command_prompt () {
	local my_git_ps1="\033[0m"
	if test -f /usr/share/git/git-prompt.sh; then
		source /usr/share/git/git-prompt.sh
		my_git_ps1=' \033[0;32m$(__git_ps1 "(%s)")\033[0m'
	fi
	local my_usr_host='\033[0;32m\u\033[0;37m@\033[0;32m\h'
	local my_pwd='\033[0;36m\W'
	local my_time='\033[0;34m\A'
	local my_prompt='\$ '
	PS1="$my_usr_host $my_pwd $my_time$my_git_ps1\\n$my_prompt"
}
__my_command_prompt

alias ...='cd ../../'
alias CH='./configure --help'
alias CO=./configure
alias da='du -sch'
alias dir='command ls -lSrah'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='command ls -l --group-directories-first --color=auto -v'
alias la='command ls -la --group-directories-first --color=auto -v'
alias lad='command ls -d .*(/)'
alias lh='command ls -hAl --group-directories-first --color=auto -v'
alias ll='command ls -l --group-directories-first --color=auto -v'
alias ls='command ls --group-directories-first --color=auto -v'
alias lsa='command ls -a .*(.)'
alias lsbig='command ls -flh *(.OL[1,10])'
alias lsd='command ls -d *(/)'
alias lse='command ls -d *(/^F)'
alias lsl='command ls -l *(@)'
alias lsnew='command ls -rtlh *(D.om[1,10])'
alias lsnewdir='command ls -rthdl *(/om[1,10]) .*(D/om[1,10])'
alias lsold='command ls -rtlh *(D.Om[1,10])'
alias lsolddir='command ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])'
alias lss='command ls -l *(s,S,t)'
alias lssmall='command ls -Srl *(.oL[1,10])'
alias lsw='command ls -ld *(R,W,X.^ND/)'
alias lsx='command ls -l *(*)'
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'
alias term2iso='echo '\''Setting terminal to iso mode'\'' ; print -n '\''\e%@'\'
alias term2utf='echo '\''Setting terminal to utf-8 mode'\''; print -n '\''\e%G'\'
alias top10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
alias xclipboard='xclip -selection clipboard'


# fortune -a | \
#	$(shuf -n 1 -e cowsay cowthink) \
		#-$(shuf -n 1 -e b d g p s t w y) \
		#-f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -W66
