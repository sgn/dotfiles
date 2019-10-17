if [ -f /lib/ld-musl-* ]; then
	alias xlibc-install='sudo xbps-install -r /xlibc'
	alias xlibc-remove='sudo xbps-remove -r /xlibc'
	alias xlibc-query='xbps-query -r /xlibc'
	alias xzoom="xlibc sh -c 'LD_LIBRARY_PATH=/opt/zoom /opt/zoom/zoom'"
fi
