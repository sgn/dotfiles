all::

LN := ln -fP
MKDIR := mkdir -p -m 0700

ALL_FILES = $(shell find . -type f -a -perm -0100)
XDIR = bin/
OUTDIR = $(HOME)/$(XDIR)
OUT_FILES = $(subst ./,$(OUTDIR),$(ALL_FILES))

all:: all-files

all-files: $(OUT_FILES)

var:
	@echo $(OUT_FILES)

$(OUTDIR):
	@echo "	MKDIR $@"
	@$(MKDIR) $@

$(OUTDIR)%: %
	@echo "	INSTALL $(XDIR)$<"
	@$(LN) $(CURDIR)/$< $@
