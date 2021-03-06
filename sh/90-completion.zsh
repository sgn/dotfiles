autoload compinit
compinit -d "${HOME}/.cache/zsh/zcompdump"

# provide verbose completion information
zstyle ':completion:*'                 verbose true
# zstyle ':completion:*:-command-:*:'    verbose false
# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'                 menu select=5
zstyle ':completion:*' special-dirs ..

zstyle ':completion:*:approximate:'    max-errors 3
# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# start menu completion only if it couldn't find any unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:correct:*'       prompt 'correct to: %e'
zstyle ':completion:*:correct:*'       original true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions

# activate menu
zstyle ':completion:*:history-words'   list false
zstyle ':completion:*:history-words'   menu yes
# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*'   completer _history

# match uppercase from lowercase
zstyle ':completion:*' matcher-list \
				'' \
				'm:{[:lower:]}={[:upper:]}' \
				'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# separate matches into groups
zstyle ':completion:*:matches'         group yes
zstyle ':completion:*'                 group-name ''

zstyle ':completion:*:messages'        format '%d'

# describe options in full
zstyle ':completion:*:options'         auto-description '%d'
zstyle ':completion:*:options'         description yes

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'
# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path      \
				/usr/local/sbin \
				/usr/local/bin  \
				/usr/sbin       \
				/usr/bin        \
				/sbin           \
				/bin            \
				/usr/X11R6/bin

_force_rehash() {
	(( CURRENT == 1 )) && rehash
	return 1  # Because we didn't really complete anything
}

# TODO
setopt correct
zstyle -e ':completion:*' completer '
	if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
		_last_try="$HISTNO$BUFFER$CURSOR"
		reply=(_complete _match _ignored _prefix _files)
	elif [[ $words[1] == (rm|mv) ]] ; then
		reply=(_complete _files)
	else
		reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
	fi
	'

zstyle ':completion:*' use-cache  yes
zstyle ':completion:*:complete:*' cache-path "${HOME}/.cache/zsh"

if [[ -r ~/.ssh/config ]]; then
	_ssh_config_hosts=(${${(s: :)${(ps:\t:)${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }}}:#*[*?]*})
else
	_ssh_config_hosts=()
fi
if [[ -r ~/.ssh/known_hosts ]]; then
	_ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*})
else
	_ssh_hosts=()
fi
if [[ -r /etc/hosts ]]; then
	: ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
else
	_etc_hosts=()
fi
hosts=($(hostname) "$_ssh_config_hosts[@]" "$_ssh_hosts[@]" "$_etc_hosts[@]" localhost)
zstyle ':completion:*:hosts' hosts $hosts

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp df feh gpasswd head hnb mv pal stow uname ; do
	[[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done;
unset compcom
