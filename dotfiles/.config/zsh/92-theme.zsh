setopt promptsubst
autoload promptinit
promptinit
prompt personal
case "$TERM" in
	linux) recolor ;;
	*) : ;;
esac
