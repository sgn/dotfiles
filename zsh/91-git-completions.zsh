if [ -f ~/src/git/contrib/completion/git-completion.zsh ]; then
	_git() {
		source ~/src/git/contrib/completion/git-completion.zsh "$@"
	}
	compdef _git git gitk
fi
