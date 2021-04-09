;;;; Emacs configuration

(setq gc-cons-threshold 100000000)
(setq debug-on-error t)

;;;; Prefer newer source over old bytecode
(setq load-prefer-newer t)

;;;; load-path
;;; our configuration
(add-to-list 'load-path "~/.emacs.d/elisp/")

;;; before configuration local hook, ignore error if not exist
(load "local-first" t)
(load "local-generated" t)

;;;; Core configuration
(require 'sgn-general)

;;;; Evil
(setq evil-want-integration t
      evil-want-keybinding nil)
(when (require 'evil nil t)
  (require 'sgn-init-evil))

;;;; Autocomplete
(when (require 'company nil t)
  (setq company-idle-delay nil))

;;;; cc-mode
(with-eval-after-load 'cc-mode
  (require 'sgn-init-cc))

(with-eval-after-load 'lisp-mode
  (add-hook 'lisp-mode-hook 'sgn/turn-off-indent-tabs))

(with-eval-after-load 'tex-mode
  (add-hook 'tex-mode-hook 'sgn/turn-off-indent-tabs))

(when (require 'hl-todo nil t)
  (add-to-list 'hl-todo-keyword-faces
               `("REVIEW"
                 .
                 ,(alist-get "TODO" hl-todo-keyword-faces nil nil 'equal)))
  (global-hl-todo-mode)
  (define-key hl-todo-mode-map (kbd "M-s t") 'hl-todo-occur))

(require 'org)
(require 'org-capture)
;; (require 'org-contacts)

;;;; Shell
(with-eval-after-load 'sh-script
  (require 'sgn-init-sh))
(add-to-list 'auto-mode-alist '("template" . sh-mode))
(add-to-list 'auto-mode-alist '("/\\.?zsh" . sh-mode))

;;;; Spelling
(when (require 'flyspell nil t)
  (defun sgn/toggle-flyspell ()
    "Toggle `flyspell-mode'."
    (interactive)
    (if (derived-mode-p 'prog-mode)
      (flyspell-prog-mode)
      (flyspell-mode))
  (when flyspell-mode (flyspell-buffer)))
  (global-set-key (kbd "<f7>") 'sgn/toggle-flyspell))

(require 'sgn-whitespace-mode)

;;(when (require 'rainbow-delimiters nil t)
  ;;(add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Never kill scratch
;; https://www.reddit.com/r/emacs/comments/4cmfwp/scratch_buffer_hacks_to_increase_its_utility/
(defun sgn-immortal-scratch ()
  (if (eq (current-buffer) (get-buffer "*scratch*"))
      (progn (bury-buffer) nil)
    t))
(add-hook 'kill-buffer-query-functions 'sgn-immortal-scratch)

;;; Finalization

;;; Don't let `customize' ruin my config.
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name
         (format "emacs-custom-%s.el"
                 (user-uid))
         temporary-file-directory)))
(load custom-file t)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

; init.el ends here
