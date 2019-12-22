all::

ROOT ?= $(shell cd $(CURDIR)/.. && pwd)
uname_S := $(shell uname -s)
ZSH_FILES :=
GEN_FILES :=

ZSH_FILES += 00-prof.zsh
ZSH_FILES += 01-setup.zsh
ZSH_FILES += 10-setopt.zsh
ZSH_FILES += 20-variables.zsh
ZSH_FILES += 30-modules.zsh
GEN_FILES += 40-autoload-functions.zsh
ZSH_FILES += 40-autoload-functions.zsh
ZSH_FILES += 70-key-binding.zsh
ZSH_FILES += 70-alias-grml.zsh
ZSH_FILES += 70-zle-grml.zsh
ZSH_FILES += 80-alias-core-util.zsh
ZSH_FILES += 80-alias-misc.zsh
ZSH_FILES += 80-functions.zsh
ZSH_FILES += 80-functions-grml.zsh
ZSH_FILES += 90-completion.zsh
ZSH_FILES += 91-git-completions.zsh
ZSH_FILES += 91-pass.zsh
ZSH_FILES += 91-prefer-tui-browser.zsh
ZSH_FILES += 91-term-title.zsh

ifeq ($(wildcard 92-prompt-battery.$(uname_S).zsh),92-prompt-battery.$(uname_S).zsh)
ZSH_FILES += 92-prompt-battery.$(uname_S).zsh
endif

ZSH_FILES += 92-theme.zsh
ZSH_FILES += 93-xlibc.zsh
GEN_FILES += 98-bundle.zsh
ZSH_FILES += 98-bundle.zsh
ZSH_FILES += 99-cowsay.zsh

ifeq ($(wildcard local.zsh),local.zsh)
ZSH_FILES += local.zsh
endif

all:: $(HOME)/.zshrc.zwc

clean:
	$(RM) $(HOME)/.zshrc $(HOME)/.zshrc.zwc
	$(RM) $(GEN_FILES)

%.zwc: %
	@echo "\tCOMPILE $<"
	@zsh -c 'zcompile $<'

$(HOME)/.zshrc: $(ZSH_FILES)
	@echo "\tGEN $@"
	@cat $(ZSH_FILES) >$@

%: %.in
	@echo "\tGEN zsh/$@"
	@sed -e 's:[$$]DOTFILES:$(ROOT):' \
		-e 's:__CURDIR__:$(CURDIR):' \
		$< >$@
