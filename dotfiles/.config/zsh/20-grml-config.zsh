NOTITLE=1
GRML_NO_APT_ALIASES=1
GRML_DISPLAY_BATTERY=1
GRML_NO_DEFAULT_LOCALE=1

if test -r "${XDG_CONFIG_HOME}/grml/etc/zsh/zshrc"; then
	source "${XDG_CONFIG_HOME}/grml/etc/zsh/zshrc"
fi
