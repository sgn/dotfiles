if command -v fortune >/dev/null 2>&1; then
	fortune -a | \
		$(shuf -n 1 -e cowsay cowthink) \
			-$(shuf -n 1 -e b d g p s t w y) \
			-f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -W 76
fi
