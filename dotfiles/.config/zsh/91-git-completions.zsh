if [ -f ~/workspace/git/contrib/completion/git-completion.zsh ]; then
	_git() {
		source ~/workspace/git/contrib/completion/git-completion.zsh "$@"
	}
	compdef _git git gitk
fi
