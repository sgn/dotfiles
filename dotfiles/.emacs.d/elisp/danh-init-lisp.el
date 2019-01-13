;;; Lisp

(with-eval-after-load 'lispyville
  (lispyville-set-key-theme
   '(operators            ; Add equivalent for lispy-delete?
     c-w                  ; Bind M-backspace to lispyville-delete-backward-word?
     (escape insert)
     slurp/barf-cp
     ;; (mark insert)
     mark-toggle
     ))
  (lispyville--define-key '(motion normal visual)
    (kbd "M-h") #'lispyville-previous-opening
    (kbd "M-l") #'lispyville-next-opening
    (kbd "M-j") #'lispy-down
    (kbd "M-k") #'lispy-up
    (kbd "M-H") #'lispy-down-slurp
    (kbd "M-J") #'lispyville-drag-forward
    (kbd "M-K") #'lispyville-drag-backward
    (kbd "M-L") #'lispy-up-slurp
    (kbd "C-x C-e") #'lispy-eval
    (kbd "C-j") #'lispy-split
    (kbd "C-J") #'lispy-join
    (kbd "C-1") #'lispy-describe-inline
    (kbd "C-2") #'lispy-arglist-inline
    (kbd "C-4") #'lispy-x
    (kbd "<f12>") #'lispy-goto-symbol
    ;; TODO: lispy-eval-and-replace
    "(" #'lispy-left
    ")" #'lispy-right
    "=" #'lispyville-prettify)
  (lispyville--define-key 'insert
    (kbd "<backspace>") 'lispy-delete-backward
    ";" 'lispy-comment
    ":" 'lispy-colon
    "'" 'lispy-tick
    "`" 'lispy-backtick
    ;; "\"" 'lispy-quotes ;; too annoyed for me
    (kbd "C-9") 'lispy-left
    (kbd "C-0") 'lispy-right-nostring)
  (lispyville--define-key '(motion normal)
    "Q" 'special-lispy-teleport
    "q" 'lispy-ace-paren
    "t" 'lispy-ace-char
    "Y" 'lispy-new-copy
    (kbd "S-<return>") 'lispy-eval-other-window
    "p" 'lispy-paste
    (kbd "M-C") 'lispy-clone
    "D" 'lispy-kill)

  (lispy-define-key lispy-mode-map-special "C" 'lispy-clone))

(defun danh/init-lispy ()
  (when (require 'lispy nil t)
    ;; (set-face-foreground 'lispy-face-hint "#FF00FF")
    (when (require 'lispyville nil t)
      (add-hook 'lispy-mode-hook 'lispyville-mode))
    (lispyville-mode)))

(defun danh/outline-lisp ()
  "show outline of an elisp file"
  (interactive)
  (occur "^;;;;+"))

(define-key lisp-mode-shared-map (kbd "C-x ?") 'danh/outline-lisp)

(dolist (hook '(common-lisp-lisp-mode-hook
                emacs-lisp-mode-hook
                scheme-mode-hook))
  (add-hook hook 'danh/turn-off-indent-tabs)
  (add-hook hook 'danh/init-lispy))

;;;; Common LISP.
(setq inferior-lisp-program "sbcl --noinform")

;;;; Scheme.
(with-eval-after-load 'scheme-mode
  (require 'geiser-impl)
  (setq geiser-active-implementations '(racket guile mit)
        geiser-default-implementation 'guile
        geiser-repl-save-debugging-history-p t
        geiser-repl-history-size 5000
        geiser-repl-history-filename (expand-file-name
                                      "geiser_history"
                                      user-emacs-directory)))

(provide 'danh-init-lisp)

;; danh-init-lisp.el ends here
