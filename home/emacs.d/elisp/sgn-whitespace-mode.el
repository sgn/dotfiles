;;;; Whitespace rules
;;; `tab-mark' has a pitfall when tab occurs only 1 spaces!?
(require 'whitespace)
(setq whitespace-style
      '(face empty indentation
             space-after-tab space-before-tab
             tab-mark newline-mark
             trailing line-tail))

;; `two-column' binds to `<f2>' in `auto-load'
;; let it bind first and we'll rebind.
(require 'two-column)
(global-set-key (kbd "<f2>") 'whitespace-mode)

(provide 'sgn-whitespace-mode)
