MODULES=$(shell awk '/path =/{print $$NF}' .gitmodules)
MODULE_FILE=$(MODULES:=/README.md)
MODULE_TAR=$(MODULES:=.tar)
PREFIX=dotfiles
VOLATILE_FILES=\

.PHONY: all
all: submodule $(VOLATILE_FILES)
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

%: src/%.in
	sed -e 's!__BIN__!$(CURDIR)/bin!g' $< > $@

.PHONY: cron
cron:
	@echo installing cron job
	(crontab -l 2>/dev/null | sed '/ssoma/d; \,syncmail.sh,d; \,battery.sh,d'; \
	printf '%s\n' \
	'*/10 * * * * ssoma sync --cron' \
	'*/2  * * * * $(CURDIR)/bin/syncmail.sh' \
	'*/3  * * * * $(CURDIR)/bin/battery.sh' \
	) | crontab -

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
	find . -name '*.tar' -exec rm -f {} +
	rm -f *.tar.gz
