all::

ROOT ?= $(shell cd $(CURDIR)/.. && pwd)
uname_S := $(shell uname -s)
BASH_FILES :=
ZSH_FILES :=
GEN_FILES :=

BASH_FILES += 00-setup.sh
BASH_FILES += 80-alias-core-util.sh
BASH_FILES += 80-alias-misc.sh
BASH_FILES += 80-functions.sh
BASH_FILES += 90-prompt.bash
BASH_FILES += 91-prefer-tui-browser.sh
BASH_FILES += 93-xlibc.sh
BASH_FILES += 99-cowsay.sh

ZSH_FILES += 00-prof.zsh
ZSH_FILES += 00-setup.sh
ZSH_FILES += 01-setup.zsh
ZSH_FILES += 10-setopt.zsh
ZSH_FILES += 20-variables.zsh
ZSH_FILES += 30-modules.zsh
GEN_FILES += 40-autoload-functions.zsh
ZSH_FILES += 40-autoload-functions.zsh
ZSH_FILES += 70-key-binding.zsh
ZSH_FILES += 70-alias-grml.zsh
ZSH_FILES += 70-zle-grml.zsh
ZSH_FILES += 80-alias-core-util.sh
ZSH_FILES += 80-alias-misc.sh
ZSH_FILES += 80-functions.sh
ZSH_FILES += 80-functions.zsh
ZSH_FILES += 80-functions-grml.zsh
ZSH_FILES += 90-completion.zsh
ZSH_FILES += 91-pass.zsh
ZSH_FILES += 91-prefer-tui-browser.sh
ZSH_FILES += 91-term-title.zsh

ifeq ($(wildcard 92-prompt-battery.$(uname_S).zsh),92-prompt-battery.$(uname_S).zsh)
ZSH_FILES += 92-prompt-battery.$(uname_S).zsh
endif

ZSH_FILES += 92-theme.zsh
ZSH_FILES += 93-xlibc.sh
GEN_FILES += 98-bundle.zsh
ZSH_FILES += 98-bundle.zsh
ZSH_FILES += 99-cowsay.sh

ifeq ($(wildcard local.sh),local.sh)
BASH_FILES += local.sh
ZSH_FILES  += local.sh
endif

ifeq ($(wildcard local.bash),local.bash)
BASH_FILES += local.bash
endif

ifeq ($(wildcard local.zsh),local.zsh)
ZSH_FILES += local.zsh
endif

all:: $(HOME)/.bashrc $(HOME)/.zshrc.zwc

clean:
	$(RM) $(HOME)/.bashrc
	$(RM) $(HOME)/.zshrc $(HOME)/.zshrc.zwc
	$(RM) $(GEN_FILES)

$(HOME)/.bashrc: $(BASH_FILES)
	@echo "	GEN $@"
	@cat $(BASH_FILES) >$@

%.zwc: %
	@echo "	COMPILE $<"
	@zsh -c 'zcompile $<'

$(HOME)/.zshrc: $(ZSH_FILES)
	@echo "	GEN $@"
	@cat $(ZSH_FILES) >$@

%: %.in
	@echo "	GEN zsh/$@"
	@sed -e 's:[$$]DOTFILES:$(ROOT):' \
		-e 's:__CURDIR__:$(CURDIR):' \
		$< >$@
