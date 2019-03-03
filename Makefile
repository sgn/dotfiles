MODULES=$(shell awk '/path =/{print $$NF}' .gitmodules)
MODULE_FILE=$(MODULES:=/README.md)
MODULE_TAR=$(MODULES:=.tar)
prefix?=dotfiles
PREFIX?=$(prefix:/%=%)

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

.PHONY: dist
dist: dotfiles.tar.gz

%.gz: %
	gzip --force $<

dotfiles.tar: $(MODULE_TAR)
	git archive --format=tar --prefix=$(PREFIX)/ -o $@ HEAD
	tar Avf $@ $?

%.tar: %/
	git -C $< archive --format=tar --prefix=$(PREFIX)/$< -o $(CURDIR)/$@ HEAD

.PHONY: clean
clean:
	find . -name '*.tar' -exec rm -f {} +
	rm -f dotfiles.tar.gz
