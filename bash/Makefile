all::

BASH_FILES :=

BASH_FILES += 00-setup.bash
BASH_FILES += 80-alias-core-util.bash
BASH_FILES += 80-alias-misc.bash
BASH_FILES += 90-prompt.bash
BASH_FILES += 91-prefer-tui-browser.bash
BASH_FILES += 93-xlibc.bash
BASH_FILES += 99-cowsay.bash
BASH_FILES += local.bash

all:: $(HOME)/.bashrc

clean:
	$(RM) $(HOME)/.bashrc

$(HOME)/.bashrc: $(BASH_FILES)
	@echo "GEN $@"
	@$(RM) $@
	@cat $^ >$@

local.bash:
	@if test -f local.rc; then \
		mv local.rc local.bash; \
	else \
		touch $@; \
	fi
