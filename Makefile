all::

MODULES=$(shell awk '/path =/{print $$NF}' .gitmodules)
MODULE_FILE=$(MODULES:=/README.md)
MODULE_TAR=$(MODULES:=.tar)
PREFIX=dotfiles
ROOT = $(CURDIR)

export ROOT

LOCAL_FILES=\
	dotfiles/.config/mutt/aliases \
	dotfiles/.config/mutt/local.rc \
	dotfiles/.config/local.profile \
	dotfiles/.config/local.xprofile \

.PHONY: all
all:: submodule $(LOCAL_FILES)
	@mkdir -p -m 700 "${HOME}/.gnupg"
	@$(MAKE) -C bash
	@$(MAKE) -C zsh
	@echo "LINK configuration files"
	@stow -t "${HOME}" dotfiles

$(LOCAL_FILES):
	@touch $@

.PHONY: var
var:
	@echo $(MODULE_FILE)

.PHONY: submodule
submodule: $(MODULE_FILE)

.PHONY: update
update: update-submodule

.PHONY: update-submodule
$(MODULE_FILE) update-submodule:
	@echo "Initialise/Update all submodules"
	@git submodule update --init

%: %.in
	@echo "GEN $@"
	@sed -e 's!__BIN__!$(CURDIR)/bin!g' $< > $@

.PHONY: cron
cron: cron.sed
	@echo installing cron job
	@crontab -l 2>/dev/null | sed -f cron.sed | crontab -

.PHONY: dist
dist: $(PREFIX).tar.gz

%.gz: %
	@gzip --force $<

$(PREFIX).tar: $(MODULE_TAR)
	@git archive --format=tar --prefix=$(PREFIX)/ -o $@ HEAD
	@tar Avf $@ $?

%.tar: %/
	@git -C $< archive --format=tar --prefix=$(PREFIX)/$< -o $(CURDIR)/$@ HEAD

.PHONY: clean
clean:
	$(RM) $(PREFIX).tar.gz $(PREFIX).tar
	$(RM) $(MODULE_TAR)
	@$(MAKE) -C bash clean
	@$(MAKE) -C zsh clean
