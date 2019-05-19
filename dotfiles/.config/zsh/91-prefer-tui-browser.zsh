# stop rtv from launching firefox
for i in w3m elinks lynx links; do
	command -v $i >/dev/null 2>&1 && \
		BROWSER=$i && \
		export BROWSER && \
		break
done
