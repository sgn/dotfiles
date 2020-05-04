all::

CP := cp -R -f
LN := ln -fP
MKDIR := mkdir -p
TOUCH := touch

ALL_FILES = $(shell find . -type f -a -not -name Makefile -a -not -name '*.sw?')
OUT_FILES = $(subst ./,$(HOME)/.,$(ALL_FILES))
ALL_SYMLINKS = $(shell find . -type l)
OUT_SYMLINKS = $(subst ./,$(HOME)/.,$(ALL_SYMLINKS))
LOCAL_FILES=\
	$(HOME)/.config/mutt/aliases \
	$(HOME)/.config/mutt/local.rc \
	$(HOME)/.config/local.profile \
	$(HOME)/.config/local.xprofile \

.PHONY: all all-real xlink localfiles var

all:: all-real

all-real: xlink localfiles

var:
	@echo $(OUT_FILES)
	@echo $(OUT_SYMLINKS)

xlink: $(OUT_FILES) $(OUT_SYMLINKS)

localfiles: $(LOCAL_FILES)

$(OUT_FILES): $(HOME)/.%: %
	@../xinstall.sh $<

# This is a special rule for supervise link to /run
# It doesn't work for top-level dotfiles
$(OUT_SYMLINKS):
	@echo "\tINSTALL $(subst $(HOME)/,,$@)"
	@$(MKDIR) $(dir $@)
	@$(CP) $(subst $(HOME)/.,,$@) $(dir $@)

$(LOCAL_FILES): $(SUBDIRS)
	@$(MKDIR) $(dir $@)
	@$(TOUCH) $@
