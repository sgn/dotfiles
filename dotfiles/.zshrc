#!/usr/bin/zsh

if test -z "${DOTFILES_HOME}"; then
	source ~/.profile
fi

ls_options=( '--group-directories-first' )
NOTITLE=1
GRML_NO_APT_ALIASES=1
GRML_DISPLAY_BATTERY=1
GRML_NO_DEFAULT_LOCALE=1

D_EXTERNAL="${DOTFILES_HOME}/external"

D_EXT_SOURCE="${D_EXTERNAL}/grml/etc/zsh/zshrc"
if test -f "${D_EXT_SOURCE}"; then
	source "${D_EXT_SOURCE}"
fi

bindkey -v

#function virtual_env_prompt () {
#    REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
#}
#grml_theme_add_token  virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
zstyle ':prompt:grml:left:setup' items rc change-root user at host path vcs time shell-level newline percent

D_EXT_SOURCE="${D_EXTERNAL}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if test -f "${D_EXT_SOURCE}"; then
	source "${D_EXT_SOURCE}"
fi

D_EXT_SOURCE="${D_EXTERNAL}/zsh-history-substring-search/zsh-history-substring-search.zsh"
if test -f "${D_EXT_SOURCE}"; then
	source "${D_EXT_SOURCE}"
fi

## set command suggestion from history
D_EXT_SOURCE="${D_EXTERNAL}/zsh-autosuggestions/zsh-autosuggestions.zsh"
if test -f "${D_EXT_SOURCE}"; then
	source "${D_EXT_SOURCE}"
	bindkey '^J' autosuggest-accept
	export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
fi

source "${D_EXTERNAL}/base16-gruvbox-dark-hard.sh"

unset D_EXT_SOURCE
unset D_EXTERNAL

## press ctrl-q to quote line:
mquote () {
     zle vi-beginning-of-line
     zle vi-forward-word
     # RBUFFER="'$RBUFFER'"
     RBUFFER=${(q)RBUFFER}
     zle end-of-line
}
zle -N mquote && bindkey '^Q' mquote

# just type '...' to get '../..'
rationalise-dot() {
local MATCH
if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
	LBUFFER+=/
	zle self-insert
	zle self-insert
else
	zle self-insert
fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
## without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

bindkey '\eq' push-line-or-edit

## some popular options ##

## add `|' to output redirections in the history
setopt histallowclobber

## try to avoid the 'zsh: no matches found...'
setopt nonomatch

## warning if file exists ('cat /dev/null > ~/.zshrc')
setopt NO_clobber

## don't warn me about bg processes when exiting
#setopt nocheckjobs

## alert me if something failed
setopt printexitvalue

## with spelling correction, assume dvorak kb
#setopt dvorak

## Allow comments even in interactive shells
setopt interactivecomments

## changed completer settings
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix

## get top 10 shell commands:
alias top10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

## Execute \kbd{./configure}
alias CO="./configure"

## Execute \kbd{./configure --help}
alias CH="./configure --help"

## miscellaneous code ##

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

## Set a search path for the cd builtin
#cdpath=(.. ~)

## variation of our manzsh() function; pick you poison:
#manzsh()  { /usr/bin/man zshall |  most +/"$1" ; }

## Switching shell safely and efficiently? http://www.zsh.org/mla/workers/2001/msg02410.html
#bash() {
#    NO_SWITCH="yes" command bash "$@"
#}
restart () {
    exec $SHELL $SHELL_ARGS "$@"
}

## Handy functions for use with the (e::) globbing qualifier (like nt)
contains() { grep -q "$*" $REPLY }
sameas() { diff -q "$*" $REPLY &>/dev/null }
ot () { [[ $REPLY -ot ${~1} ]] }

## List all occurrences of programm in current PATH
plap() {
	emulate -L zsh
	if [[ $# = 0 ]] ; then
		echo "Usage:    $0 program"
		echo "Example:  $0 zsh"
		echo "Lists all occurrences of program in the current PATH."
	else
		ls -l ${^path}/*$1*(*N)
	fi
}

## Find out which libs define a symbol
lcheck() {
	if [[ -n "$1" ]] ; then
		nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
	else
		echo "Usage: lcheck <function>" >&2
	fi
}

## Memory overview
memusage() {
	ps aux | awk '{if (NR > 1) print $5; if (NR > 2) print "+"} END { print "p" }' | dc
}

## print hex value of a number
hex() {
	emulate -L zsh
	if [[ -n "$1" ]]; then
		printf "%x\n" $1
	else
		print 'Usage: hex <number-to-convert>'
		return 1
	fi
}

weather () {
	station="${@:-Ho_Chi_Minh}"
	station="${station:gs/ /_/}"
	curl "http://wttr.in/${station}"
}

xbps-list() {
	xbps-query -m |
		sed -E 's/-[[:digit:]]+(\.(git)?[[:digit:]]+)*(_[[:digit:]]+)?(\.r[[:digit:]])?$//'
}

## log out? set timeout in seconds...
## ...and do not log out in some specific terminals:
#if [[ "${TERM}" == ([Exa]term*|rxvt|dtterm|screen*) ]] ; then
#    unset TMOUT
#else
#    TMOUT=1800
#fi

alias xclipboard='xclip -selection clipboard'
alias fgrep='fgrep --color=auto'

# stop rtv from launching firefox
for i in w3m elinks lynx links; do
	command -v $i >/dev/null 2>&1 && \
		BROWSER=$i && \
		export BROWSER && \
		break
done

if command -v fortune >/dev/null 2>&1; then
	fortune -a | \
		$(shuf -n 1 -e cowsay cowthink) \
			-$(shuf -n 1 -e b d g p s t w y) \
			-f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -W 76
fi
