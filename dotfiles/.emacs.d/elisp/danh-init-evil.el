;;; Evil

;;;; Basic
(evil-mode 1)

(setq evil-cross-lines t
      evil-move-beyond-eol t
      evil-want-fine-undo t)

(setq-default evil-symbol-word-search t)

;;;; Comment
(when (require 'evil-commentary nil t)
  (evil-global-set-key 'normal "gc" 'evil-commentary)
  (evil-global-set-key 'normal "gy" 'evil-commentary-yank))

;;;; Terminal
(evil-set-initial-state 'term-mode 'emacs)

;;;; With Editor
(when (require 'with-editor nil t)
  (add-hook 'with-editor-mode-hook 'evil-insert-state))

;;;; Window management
(danh/global-set-keys
 "s-t" 'evil-window-top-left
 "H-t" 'evil-window-top-left
 "s-b" 'evil-window-bottom-right
 "H-b" 'evil-window-bottom-right)

;; https://emacs.stackexchange.com/questions/608/evil-map-keybindings-the-vim-way
(defun danh/jump-to-tag ()
   (interactive)
   (evil-execute-in-emacs-state)
   (call-interactively (key-binding (kbd "M-."))))
(evil-global-set-key 'normal (kbd "<f12>") 'danh/jump-to-tag)

;;;; Multiedit
(when (require 'evil-multiedit nil t)
  ;; we won't need to toggle iedit anyway
  (global-set-key (kbd "C-;") 'evil-multiedit-match-all)
  (evil-multiedit-default-keybinds))

(setq evil-collection-setup-minibuffer t
      evil-collection-term-sync-state-and-mode-p t)
(when (require 'evil-collection nil t)
  (evil-collection-init))

(provide 'danh-init-evil)

;; danh-init-evil.el ends here
