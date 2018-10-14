;;; Spelling --- Check spelling initialization
;; Copyright (c) DOAN Danh
;;; Commentary:
;; This file initialises spelling, conformance and other check

;;; Code:
(require 'whitespace)
(defun danh/toogle-conformance-check ()
  "Toggle `flyspell-mode' and `whitespace-mode'."
  (interactive)
  (if (derived-mode-p 'prog-mode)
      (flyspell-prog-mode)
    (flyspell-mode))
  (when flyspell-mode
    (flyspell-buffer))
  (whitespace-mode 'toggle))
(global-set-key (kbd "C-<f9>") 'danh/toogle-conformance-check)

(define-key flycheck-mode-map (kbd "<f9>") 'helm-flycheck)

;;;; Whitespace rules
;;; `tab-mark' has a pitfall when tab occurs only 1 spaces!?
(setq whitespace-style
      '(face empty indentation
             space-after-tab space-before-tab
             tab-mark
             trailing line-tail))

(provide 'danh-init-spelling)
;;; danh-init-spelling.el ends here
