;;; Sh

(setq-default sh-shell-file "/bin/sh")

;;;; Faces
(set-face-foreground 'sh-heredoc "#00bfff")
(set-face-bold 'sh-heredoc nil)

(defvaralias 'sh-basic-offset 'tab-width)
(defvaralias 'sh-indentation 'sh-basic-offset)

(setq sh-indent-for-case-label 0
      sh-indent-comment t
      sh-indent-for-case-alt '+)

;;;; Skeletons
(define-skeleton danh/sh-commands-or-die
  "Insert a loop that exits if any of the commands is not found in path."
  "Command names: "
  > "for i " @ str "; do" \n
  > "if ! command -v \"$i\" >/dev/null 2>&1; then" \n
  > "echo >&2 \"'$i' not found\"" \n
  > "exit 1" \n
  "fi" > \n
  "done" > \n \n)

(define-skeleton danh/sh-ifcommand
  "Insert a test to check if command is found in path."
  "Command name: "
  > "if command -v " @ str " >/dev/null 2>&1; then" \n
  > @ _ \n
  "fi" > \n)

(define-skeleton danh/sh-while-getopts
  "Insert a getops prototype."
  "optstring: "
  > "usage() {" \n
  > "cat<<EOF" \n
  "Usage: ${1##*/} [OPTIONS] FILES

Options:

  -h:  Show this help.

EOF
}" > \n
\n
> "while getopts :" str " OPT; do" \n
> "case $OPT in" \n
'(setq v1 (append (vconcat str) nil))
((prog1 (if v1 (char-to-string (car v1)))
   (if (eq (nth 1 v1) ?:)
       (setq v1 (nthcdr 2 v1)
             v2 "\"$OPTARG\"")
     (setq v1 (cdr v1)
           v2 nil)))
 > str ")" \n
 > _ v2 " ;;" \n)
> "\\?)" \n
> "usage \"$0\"" \n
"exit 1 ;;"  > \n
"esac" > \n
"done" > \n
\n
"shift $(($OPTIND - 1))" \n
"if [ $# -eq 0 ]; then" \n
> "usage \"$0\"" \n
"exit 1" \n
"fi" > \n)

(define-skeleton danh/sh-while-read
  "Insert a while read loop."
  nil
  > "while IFS= read -r i; do" \n
  > @ _ \n
  "done <<EOF" > \n
  "EOF" > \n)

(provide 'danh-init-sh)

;;; danh-init-sh.el ends here
