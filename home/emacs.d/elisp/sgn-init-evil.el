;;; Evil

;;;; Basic
(evil-mode 1)

(setq evil-want-minibuffer t)

(setq-default evil-symbol-word-search t)

;;;; With Editor
(when (require 'with-editor nil t)
  (add-hook 'with-editor-mode-hook 'evil-normal-state))

;; https://emacs.stackexchange.com/questions/608/evil-map-keybindings-the-vim-way
(defun sgn/jump-to-tag ()
   (interactive)
   (evil-execute-in-emacs-state)
   (call-interactively (key-binding (kbd "M-."))))
(evil-global-set-key 'normal (kbd "<f12>") 'sgn/jump-to-tag)

;;;; Multiedit
(when (require 'evil-multiedit nil t)
  ;; we won't need to toggle iedit anyway
  (global-set-key (kbd "C-;") 'evil-multiedit-match-all)
  (evil-multiedit-default-keybinds))

(setq evil-collection-setup-minibuffer t
      evil-collection-term-sync-state-and-mode-p t)
(when (require 'evil-collection nil t)
  (evil-collection-init))

(provide 'sgn-init-evil)

;; sgn-init-evil.el ends here
