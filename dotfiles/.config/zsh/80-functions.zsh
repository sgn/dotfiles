# Switching shell safely and efficiently?
# http://www.zsh.org/mla/workers/2001/msg02410.html
bash () {
    NO_SWITCH="yes" command bash "$@"
}

restart () {
    exec $SHELL $SHELL_ARGS "$@"
}

## Handy functions for use with the (e::) globbing qualifier (like nt)
contains () { grep -q "$*" $REPLY }
sameas () { diff -q "$*" $REPLY &>/dev/null }
ot () { [[ $REPLY -ot ${~1} ]] }
