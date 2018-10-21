;;;; Emacs configuration

(setq gc-cons-threshold 100000000)

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
        magit
        hl-todo                         ; todo
        helm-mu                         ; mu4e
        mu4e-maildirs-extension
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
        helm-youtube
        which-key
        pdf-tools
        transmission
        dracula-theme))

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
(require 'magit nil t)
(with-eval-after-load 'diff-mode
  (require 'diff-mode-))

(when (require 'hl-todo nil t)
  (add-to-list 'hl-todo-keyword-faces
               `("REVIEW" . ,(alist-get "TODO" hl-todo-keyword-faces nil nil 'equal)))
  (global-hl-todo-mode)
  (define-key hl-todo-mode-map (kbd "M-s t") 'hl-todo-occur))

(require 'org)
(require 'org-capture)
(require 'org-contacts)

;;;; Mail
;;; mu4e
(when (or (fboundp 'mu4e)
          (mapcar
            (lambda (path) (string-match "/mu4e/\\|/mu4e$" path))
            load-path))
  (require 'mu4e)
  (require 'danh-init-mu4e))
(danh/global-set-keys "C-x m" 'mu4e
                     "C-c m" 'compose-mail)

;;;; Shell
(with-eval-after-load 'sh-script
  (require 'danh-init-sh))
(add-to-list 'auto-mode-alist
             '("PKGBUILD" . sh-mode))

(require 'danh-init-youtube)

;;;; Spelling
(when (require 'flycheck nil t)
  (require 'danh-init-spelling))

;;;; Theme
(if (custom-theme-p 'dracula)
    (load-theme 'dracula t)
  (message "Notheme"))
(when (locate-file "dracula-theme.el"
		   (custom-theme--load-path)
		   '("" "c"))
  (load-theme 'dracula t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

; init.el ends here
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
