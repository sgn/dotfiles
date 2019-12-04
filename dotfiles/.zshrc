if [ -f ~/.config/zsh/zsh.zshrc ]; then
	source ~/.config/zsh/zsh.zshrc
	source ~/.config/zsh/stolen.zshrc
	source ~/.config/zsh/local.rc
else
	for f in ~/.config/zsh/*.zsh ~/.config/zsh/*.stolen; do
		source "$f"
	done; unset f
	[ -f ~/.config/zsh/local.rc ] && source ~/.config/zsh/local.rc
fi

zstyle ':vcs_info:*' enable git

## changed completer settings
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix
