#!/bin/false

load_ssh_agent() {
	ssh_agent_env=/tmp/ssh-$(id -u)
	mkdir -p -m 0700 "$ssh_agent_env"
	ssh_agent_env="$ssh_agent_env/$(uname -n).agent"
	[ -f "$ssh_agent_env" ] && . "$ssh_agent_env" >| /dev/null
	if [ ! -S "$SSH_AUTH_SOCK" ] ||\
		   [ 2 -eq "$(ssh-add -l)" ]; then
		(umask 077; ssh-agent >| "$ssh_agent_env")
		. "$ssh_agent_env" >| /dev/null
	fi
	unset ssh_agent_env
}
