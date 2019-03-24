#!/bin/false

# only kill ssh-agent on logging out from tty/ssh
# do not kill on logging out from tmux
if [ "${TERM%%[-.]*}" != "screen" ]; then
	killall -u "$USER" ssh-agent
	clear
fi
