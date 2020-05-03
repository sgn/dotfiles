__my_command_prompt () {
	local my_git_ps1='\[\033[0m\]'
	if test -f /usr/share/git/git-prompt.sh; then
		source /usr/share/git/git-prompt.sh
		my_git_ps1=' \[\033[0;32m\]$(__git_ps1 "(%s)")\[\033[0m\]'
	fi
	local my_usr_host='\[\033[0;32m\]\u\[\033[0;37m\]@\[\033[0;32m\]\h'
	local my_pwd='\[\033[0;36m\]\W'
	local my_time='\[\033[0;34m\]\A'
	local my_prompt='\$ '
	PS1="$my_usr_host $my_pwd $my_time$my_git_ps1\\n$my_prompt"
}
__my_command_prompt
unset -f __my_command_prompt
