all::

LN := ln -fP
MKDIR := mkdir -p -m 0700

ALL_FILES = $(shell find . -type f -a -not -name Makefile -a -not -name '*.sw?')
ALL_SYMLINKS = $(shell find . -type l)
SUBDIRS = $(shell find . -type d -a -not -name '.')
LOCAL_FILES=\
	$(HOME)/.config/mutt/aliases \
	$(HOME)/.config/mutt/local.rc \
	$(HOME)/.config/local.profile \
	$(HOME)/.config/local.xprofile \


all:: xlink localfiles

.PHONY: xlink $(ALL_FILES) $(ALL_SYMLINKS)
xlink: $(ALL_FILES) $(ALL_SYMLINKS)

$(ALL_FILES): subdirs
	@echo "\tLINK $@"
	@$(LN) $(CURDIR)/$@ $(HOME)/.$@

# This is a hack for supervise link to /run
# It doesn't work for top-level dotfiles
$(ALL_SYMLINKS): subdirs
	@echo "\tLINK $@"
	@$(LN) $(CURDIR)/$@ $(dir $(HOME)/.$@)

.PHONY: localfiles
localfiles: $(LOCAL_FILES)

$(LOCAL_FILES): subdirs
	@touch $@

.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

$(SUBDIRS):
	@$(MKDIR) $(HOME)/.$@
