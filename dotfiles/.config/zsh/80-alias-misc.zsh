## get top 10 shell commands:
alias top10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

## Execute \kbd{./configure}
alias CO="./configure"

## Execute \kbd{./configure --help}
alias CH="./configure --help"

alias xclipboard='xclip -selection clipboard'
