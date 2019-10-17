if [ -f ~/workspace/git/contrib/completion/git-completion.zsh ]; then
	zstyle ':completion:*:*:git:*' script \
		~/workspace/git/contrib/completion/git-completion.zsh
fi
