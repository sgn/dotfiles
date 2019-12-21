all::

ROOT ?= $(shell cd $(CURDIR)/../../.. && pwd)
uname_S := $(shell uname -s)
ZSH_FILES :=
GEN_FILES :=

ZSH_FILES += 00-prof.zsh
ZSH_FILES += 01-setup.zsh
ZSH_FILES += 10-setopt.zsh
ZSH_FILES += 20-variables.zsh
ZSH_FILES += 30-modules.zsh
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
ZSH_FILES += 92-prompt-battery.$(uname_S).zsh
ZSH_FILES += 92-theme.zsh
ZSH_FILES += 93-xlibc.zsh
GEN_FILES += 98-bundle.zsh
ZSH_FILES += 98-bundle.zsh
ZSH_FILES += 99-cowsay.zsh
ZSH_FILES += local.zsh

all:: $(HOME)/.zshrc.zwc

clean:
	$(RM) "$(HOME)/.zshrc" "$(HOME)/.zshrc.zwc"
	$(RM) $(GEN_FILES)

%.zwc: %
	zsh -c 'zcompile $<'

$(HOME)/.zshrc: $(ZSH_FILES) $(LOCAL_FILES)
	$(RM) $@
	cat $^ >$@

92-prompt-battery.$(uname_S).zsh:
	touch $@

%: %.in
	@echo "GEN $@"
	@sed -e 's:[$$]DOTFILES:$(ROOT):' $< >$@

local.zsh:
	if test -f local.rc; then \
		mv local.rc local.zsh; \
	else \
		touch $@; \
	fi
