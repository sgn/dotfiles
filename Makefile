FZSH = dotfiles/.config/zsh/
SUBMODULE=$(FZSH)zsh-history-substring-search/zsh-history-substring-search.zsh \
	  $(FZSH)zsh-autosuggestions/zsh-autosuggestions.zsh \
	  $(FZSH)zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
	  $(FZSH)grml/etc/zsh/zshrc

all: submodule
	mkdir -p "${HOME}/.gnupg"
	chmod go-rwx "${HOME}/.gnupg"
	stow -t "${HOME}" dotfiles

submodule: $(SUBMODULE)
$(SUBMODULE):
	git submodule update --init

cron: croninstall.sh
	$(SHELL) ./croninstall.sh

.PHONY: all submodule cron
