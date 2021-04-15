setopt promptsubst

case "$TERM" in
	linux) recolor ;;
	*) : ;;
esac

if [[ ! -o restricted ]]; then
	autoload vcs_info
	zstyle ':vcs_info:*' max-exports 2
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' actionformats "[%F{green}%b%F{yellow}|%F{red}%a%f] "
	zstyle ':vcs_info:*' formats	   "[%F{green}%b%f] "
fi

prompt_sgn_precmd () {
	(( ${+functions[__battery]} )) && __battery
	(( ${+functions[vcs_info]} )) && vcs_info
}

prompt_sgn_setup () {
	local newline=$'\n'
	autoload add-zsh-hook
	# secondary prompt,
	# printed when the shell needs more information to complete a command.
	PS2='\`%_> '
	# selection prompt used within a select loop.
	PS3='?# '
	# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
	PS4='+%N:%i:%e:%_> '

	# exit status of previous command if failure
	PS1='%B%F{red}%(?..%? )%f%b'
	# user@host
	PS1="${PS1}@%F{blue}%m%f "
	# cwd, truncate to 40 chars
	PS1="${PS1}%B%40<..<%~%<<%b "
	if ${ZSH_PROMPT_NO_PRECMD+false} :; then
		add-zsh-hook precmd prompt_sgn_precmd
		PS1="${PS1}\$vcs_info_msg_0_"
		RPS1="\$__battery_status"
	fi
	# source /usr/share/git/git-prompt.sh
	# PS1="${PS1}\$(__git_ps1 '(%s)')"
	# SHLVL
	PS1="${PS1}%F{red}%(3L.+ .)%f"
	PS1="${PS1}${newline}%# "
}

prompt_sgn_setup
