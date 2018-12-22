;;;; Emacs configuration

(setq gc-cons-threshold 100000000)
(setq debug-on-error t)

;;;; Prefer newer source over old bytecode
(setq load-prefer-newer t)

;;;; load-path
;;; our configuration
(add-to-list 'load-path "~/.emacs.d/elisp/")

;;; move user-emacs-directory to .cache
(setq user-emacs-directory "~/.cache/emacs/")

(setf package-selected-packages
      '(evil                            ; evil
        evil-commentary
        evil-multiedit
        evil-collection
        helm                            ; helm
        helm-ls-git
        helm-descbinds
        ;; helm-filesets
        wgrep-helm
        company                         ; company
        helm-company
        lispy                           ; lisp
        lispyville
        rainbow-delimiters
        geiser
        slime
        org-plus-contrib                ; org-mode
        helm-org-contacts
        htmlize                         ; blog
        async                           ; dired
        pinentry                        ; gpg
        ztree
        git-commit                      ; git
        hl-todo                         ; todo
        helm-mu                         ; mu4e
        flycheck                        ; flycheck
        helm-flycheck
        w3m                             ; w3m
        apel
        helm-w3m
        haskell-mode                    ; haskell
        haskell-emacs
        pass                            ; password-store
        pass-otp
        helm-pass
        markdown-mode
        helm-youtube
        which-key
        pdf-tools
        base16-theme
        transmission))

;;;; Package Management
(when (require 'package nil t)
  ;; prefer versioned byte code if exists
  (let ((versioned-dir
        (format "elpa-%s.%s" emacs-major-version emacs-minor-version)))
    (when (member versioned-dir
                  (directory-files (expand-file-name ".." package-user-dir)))
      (setq package-user-dir
            (expand-file-name (concat "../" versioned-dir) package-user-dir))))
  (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")
          ("org" . "https://orgmode.org/elpa/")))

  (package-initialize))

;;; before configuration local hook, ignore error if not exist
(load "local-before" t)

;;;; Core configuration
(require 'danh-core)

;;;; Evil
(setq evil-want-integration t
      evil-want-keybinding nil)
(when (require 'evil nil t)
  (require 'danh-init-evil))

;;;; Helm
(when (require 'helm-config nil t)
  (require 'danh-init-helm))

;;;; Autocomplete
(when (require 'company nil t)
  (setq company-idle-delay nil))

;;;; Lisp
(with-eval-after-load 'lisp-mode (require 'danh-init-lisp))
;;;; cc-mode
(with-eval-after-load 'cc-mode
  (require 'danh-init-cc))

(require 'dired)
(require 'danh-init-dired)
(when (require 'async)
  (dired-async-mode))

;;;; git
(global-git-commit-mode)
(setq vc-display-status nil
      vc-follow-symlinks t
      vc-handled-backends nil)
(remove-hook 'find-file-hook 'vc-refresh-state)

(when (require 'hl-todo nil t)
  (add-to-list 'hl-todo-keyword-faces
               `("REVIEW" . ,(alist-get "TODO" hl-todo-keyword-faces nil nil 'equal)))
  (global-hl-todo-mode)
  (define-key hl-todo-mode-map (kbd "M-s t") 'hl-todo-occur))

(require 'org)
(require 'org-capture)
(require 'org-contacts)

;;;; Mail
;; notmuch
(setq notmuch-init-file "~/.emacs.d/notmuch-config")
(autoload 'notmuch "notmuch" "notmuch mail" t)
(danh/global-set-keys "C-x m" 'notmuch
                      "C-c m" 'compose-mail)

;;;; Shell
(with-eval-after-load 'sh-script
  (require 'danh-init-sh))
(add-to-list 'auto-mode-alist '("PKGBUILD" . sh-mode))
(add-to-list 'auto-mode-alist '("template" . sh-mode))
(add-to-list 'auto-mode-alist '("/\\.?zsh" . sh-mode))

(require 'danh-init-youtube)

;;;; Spelling
(when (require 'flycheck nil t)
  (require 'danh-init-spelling))

(when (require 'rainbow-delimiters nil t)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; https://stackoverflow.com/questions/4236808/syntax-highlight-a-vimrc-file-in-emacs/4238738
(define-generic-mode 'vimrc-generic-mode
  '()
  '()
  '(("^[\t ]*:?\\(!\\|ab\\|map\\|unmap\\)[^\r\n\"]*\"[^\r\n\"]*\\(\"[^\r\n\"]*\"[^\r\n\"]*\\)*$"
     (0 font-lock-warning-face))
    ("\\(^\\|[\t ]\\)\\(\".*\\)$"
     (2 font-lock-comment-face))
    ("\"\\([^\n\r\"\\]\\|\\.\\)*\""
     (0 font-lock-string-face)))
  '("/vimrc\\'" "\\.vim\\(rc\\)?\\'")
  '((lambda ()
      (modify-syntax-entry ?\" ".")))
  "Generic mode for Vim configuration files.")

;; Never kill scratch
;; https://www.reddit.com/r/emacs/comments/4cmfwp/scratch_buffer_hacks_to_increase_its_utility/
(defun danh/immortal-scratch ()
  (if (eq (current-buffer) (get-buffer "*scratch*"))
      (progn (bury-buffer) nil)
    t))
(add-hook 'kill-buffer-query-functions 'danh/immortal-scratch)

;;;; Theme
(setq term-file-aliases '(("st-256color" . "xterm"))
      base16-theme-256-color-source "base16-shell")
(when (load-theme 'base16-tomorrow-night t)
  ;; Set the cursor color based on the evil state
  (defvar danh/base16-colors base16-tomorrow-night-colors)
  (setq evil-emacs-state-cursor   `(,(plist-get danh/base16-colors :base0D) box)
        evil-insert-state-cursor  `(,(plist-get danh/base16-colors :base0D) bar)
        evil-motion-state-cursor  `(,(plist-get danh/base16-colors :base0E) box)
        evil-normal-state-cursor  `(,(plist-get danh/base16-colors :base0B) box)
        evil-replace-state-cursor `(,(plist-get danh/base16-colors :base08) box)
        evil-visual-state-cursor  `(,(plist-get danh/base16-colors :base09) box)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
