for module in ~/.config/zsh.bundle/*; do
	module_name="${module##*/[0-9][0-9]-}"
	if test -r "$module/${module_name}.plugin.zsh"; then
		source "$module/${module_name}.plugin.zsh"
	elif test -r "$module/${module_name}.zsh"; then
		source "$module/${module_name}.zsh"
	elif test -r "$module/init.zsh"; then
		source "$module/init.zsh"
	fi
done
unset module module_name

bindkey '^J' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
