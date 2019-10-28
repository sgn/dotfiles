[ -f ~/workspace/git/contrib/completion/git-completion.zsh ] || return
_git() {
	source ~/workspace/git/contrib/completion/git-completion.zsh "$@"
}
compdef _git git gitk
