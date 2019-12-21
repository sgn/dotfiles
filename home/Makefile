all::

LN := ln -sf
MKDIR := mkdir -p -m 0700

ALL_FILES = $(shell \
	find . -type f \
		-a -not -name Makefile \
		-a -not -name '*.sw?')
SUBDIRS = $(shell find . -type d -a -not -name '.')
LOCAL_FILES=\
	$(HOME)/.config/mutt/aliases \
	$(HOME)/.config/mutt/local.rc \
	$(HOME)/.config/local.profile \
	$(HOME)/.config/local.xprofile \


all:: symlink localfiles

.PHONY: symlink $(ALL_FILES)
symlink: $(ALL_FILES)
$(ALL_FILES): subdirs
	@echo "\tLINK $@"
	@$(LN) $(CURDIR)/$@ $(HOME)/.$@

.PHONY: localfiles
localfiles: $(LOCAL_FILES)
$(LOCAL_FILES): subdirs
	@touch $@

.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)
$(SUBDIRS):
	@if [ -h '$(HOME)/.$@' ]; then $(RM) '$(HOME)/.$@'; fi
	@$(MKDIR) $(HOME)/.$@
