MODULES=$(shell awk '/path =/{print $$NF}' .gitmodules)
MODULE_FILE=$(MODULES:=/README.md)

.PHONY: all
all: submodule
	mkdir -p "${HOME}/.gnupg"
	chmod go-rwx "${HOME}/.gnupg"
	stow -t "${HOME}" dotfiles

.PHONY: var
var:
	@echo $(MODULE_FILE)

.PHONY: submodule
submodule: $(MODULE_FILE)

.PHONY: update
update: update-submodule

.PHONY: update-submodule
$(MODULE_FILE) update-submodule:
	git submodule update --init

.PHONY: cron
cron: croninstall.sh
	$(SHELL) ./croninstall.sh

