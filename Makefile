all::

MODULES     = $(shell awk '/path =/{print $$NF}' .gitmodules)
MODULE_FILE = $(MODULES:=/README.md)
MODULE_TAR  = $(MODULES:=.tar)
PREFIX      = dotfiles
ROOT        = $(CURDIR)
DESTDIR     ?= /

SUBDIRS :=
SUBDIRS += bash
SUBDIRS += bin
SUBDIRS += home
SUBDIRS += sh

export ROOT

.PHONY: all
all:: submodule $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@$(MAKE) -C $@

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

.PHONY: dist
dist: $(PREFIX).tar.gz

%.gz: %
	@gzip --force $<

$(PREFIX).tar: $(MODULE_TAR)
	@git archive --format=tar --prefix=$(PREFIX)/ -o $@ HEAD
	@tar Avf $@ $?

%.tar: %/
	@git -C $< archive --format=tar --prefix=$(PREFIX)/$< -o $(CURDIR)/$@ HEAD

system:
	@./install-etc.sh

.PHONY: clean
clean:
	$(RM) $(PREFIX).tar.gz $(PREFIX).tar
	$(RM) $(MODULE_TAR)
	@$(MAKE) -C bash clean
	@$(MAKE) -C sh clean
