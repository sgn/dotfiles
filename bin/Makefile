all::

LN := ln -sf
MKDIR := mkdir -p -m 0700

ALL_FILES = $(shell find . -type f -a -perm -0100)
XDIR = bin
OUTDIR = $(HOME)/$(XDIR)

all:: $(ALL_FILES)

$(OUTDIR):
	@if [ -h '$@' ]; then $(RM) '$@'; fi
	@$(MKDIR) $@

.PHONY: $(ALL_FILES)
$(ALL_FILES): $(OUTDIR)
	@echo "\tLINK $(XDIR)/$@"
	@$(LN) $(CURDIR)/$@ $(OUTDIR)/$@
