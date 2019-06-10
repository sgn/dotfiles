case "${TERM%-256color}" in
	st|screen) : ;;
	*) recolor ;;
esac
