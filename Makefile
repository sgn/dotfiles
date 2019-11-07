MODULES=$(shell awk '/path =/{print $$NF}' .gitmodules)
MODULE_FILE=$(MODULES:=/README.md)
MODULE_TAR=$(MODULES:=.tar)
PREFIX=dotfiles
VOLATILE_FILES=\
	dotfiles/.config/zsh/zsh.zshrc \
	dotfiles/.config/zsh/stolen.zshrc \

LOCAL_FILES=\
	dotfiles/.config/mutt/aliases \
	dotfiles/.config/mutt/local.rc \
	dotfiles/.config/local.profile \
	dotfiles/.config/local.xprofile \
	dotfiles/.config/zsh/local.rc \

.PHONY: all
all: submodule $(VOLATILE_FILES) $(LOCAL_FILES)
	mkdir -p -m 700 "${HOME}/.gnupg"
	stow -t "${HOME}" dotfiles

dotfiles/.config/zsh/%.zshrc: dotfiles/.config/zsh/*.%
	cat dotfiles/.config/zsh/*.$* >$@

$(LOCAL_FILES):
	touch $@

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

%: src/%.in
	sed -e 's!__BIN__!$(CURDIR)/bin!g' $< > $@

.PHONY: cron
cron: cron.sed
	@echo installing cron job
	crontab -l 2>/dev/null |\
		sed -f cron.sed |\
		crontab -

.PHONY: dist
dist: $(PREFIX).tar.gz

%.gz: %
	gzip --force $<

$(PREFIX).tar: $(MODULE_TAR)
	git archive --format=tar --prefix=$(PREFIX)/ -o $@ HEAD
	tar Avf $@ $?

%.tar: %/
	git -C $< archive --format=tar --prefix=$(PREFIX)/$< -o $(CURDIR)/$@ HEAD

.PHONY: clean
clean:
	$(RM) $(PREFIX).tar.gz $(PREFIX).tar
	$(RM) $(MODULE_TAR)
