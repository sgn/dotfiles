[ -f ~/.profile ] && source ~/.profile

if test "$TERM" = "linux" ; then
	printf '\033]P0282A36 \033]P84D4D4D'
	printf '\033]P1FF5555 \033]P9FF6E67'
	printf '\033]P250FA7B \033]PA5AF78E'
	printf '\033]P3F1FA8C \033]PBF4F99D'
	printf '\033]P4BD93F9 \033]PCCAA9FA'
	printf '\033]P5FF79C6 \033]PDFF92D0'
	printf '\033]P68BE9FD \033]PE9AEDFE'
	printf '\033]P7BFBFBF \033]PFF8F8F2'
	clear
fi
