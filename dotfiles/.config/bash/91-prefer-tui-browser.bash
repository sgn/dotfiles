# stop rtv from launching firefox
for browser in w3m elinks lynx links; do
	command -v $browser >/dev/null 2>&1 && \
		BROWSER=$browser && \
		export BROWSER && \
		break
done; unset browser
