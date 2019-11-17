if [ -f /lib/ld-musl-* ]; then
alias xlibc-install='sudo xbps-install -r /xlibc'
alias xlibc-remove='sudo xbps-remove -r /xlibc'
alias xlibc-query='xbps-query -r /xlibc'
xzoom () {
	xtmp=$(mktemp -d /tmp/xlibc.XXXXXXXX)
	xbps-uunshare \
		-b $xtmp:/tmp \
		-- /xlibc \
		sh -c 'LD_LIBRARY_PATH=/opt/zoom exec /opt/zoom/zoom'
}

skype () {
	xtmp=$(mktemp -d /tmp/xlibc.XXXXXXXX)
	xbps-uunshare \
		-b $xtmp:/tmp \
		-- /xlibc \
		skypeforlinux
}
fi
