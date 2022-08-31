alias zprofile='ZSH_PROFILE_RC=1 zsh'
alias da='du -sch'
alias ixpaste='curl -F "f:1=<-" ix.io'
alias termbin='nc termbin.com 9999'

if command -v xclip >/dev/null 2>&1; then
	alias clip='xclip -selection clipboard'
elif command -v clip.exe >/dev/null 2>&1; then
	alias clip='clip.exe'
fi
