NOTITLE=1
GRML_NO_APT_ALIASES=1
GRML_DISPLAY_BATTERY=1
GRML_NO_DEFAULT_LOCALE=1

if test -r "${XDG_CONFIG_HOME}/grml/etc/zsh/zshrc"; then
	source "${XDG_CONFIG_HOME}/grml/etc/zsh/zshrc"
fi

for f in ~/.config/zsh/**/*.zsh; do
	[ -f "$f" ] && source "$f"
done

#function virtual_env_prompt () {
#    REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
#}
#grml_theme_add_token  virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
zstyle ':vcs_info:*' enable git
zstyle ':prompt:grml:left:setup' items rc change-root user at host path vcs shell-level newline percent

## changed completer settings
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix

# Switching shell safely and efficiently?
# http://www.zsh.org/mla/workers/2001/msg02410.html
bash() {
    NO_SWITCH="yes" command bash "$@"
}

restart () {
    exec $SHELL $SHELL_ARGS "$@"
}

## Handy functions for use with the (e::) globbing qualifier (like nt)
contains() { grep -q "$*" $REPLY }
sameas() { diff -q "$*" $REPLY &>/dev/null }
ot () { [[ $REPLY -ot ${~1} ]] }
