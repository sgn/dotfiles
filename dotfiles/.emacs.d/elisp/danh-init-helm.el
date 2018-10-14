;;; Helm

(when (require 'helm-descbinds nil t)
  (helm-descbinds-mode))

(when (require 'wgrep-helm nil t)
  (setq wgrep-auto-save-buffer t
        wgrep-enable-key (kbd "C-x C-q")))

(when (require 'helm-ls-git nil t)
  ;; `helm-source-ls-git' must be defined manually.
  ;; See https://github.com/emacs-helm/helm-ls-git/issues/34.
  (setq helm-source-ls-git
        (and (memq 'helm-source-ls-git helm-ls-git-default-sources)
             (helm-make-source "Git files" 'helm-ls-git-source
               :fuzzy-match helm-ls-git-fuzzy-match))))

(helm-mode 1)
;; (helm-autoresize-mode 1)
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(require 'helm-find)

;;; Generic configuration.
(setq
 helm-follow-mode-persistent t
 helm-reuse-last-window-split-state t
 helm-display-header-line nil
 helm-findutils-search-full-path t
 helm-completion-mode-string ""
 helm-dwim-target 'completion
 helm-split-window-inside-p t
 helm-echo-input-in-header-line t
 helm-use-frame-when-more-than-two-windows nil

 helm-apropos-fuzzy-match t
 helm-buffers-fuzzy-matching t
 helm-eshell-fuzzy-match t
 helm-imenu-fuzzy-match t
 helm-M-x-fuzzy-match t
 helm-recentf-fuzzy-match t

 helm-buffers-end-truncated-string "…"
 helm-buffer-max-length 22

 helm-window-show-buffers-function 'helm-window-mosaic-fn
 helm-window-prefer-horizontal-split t)

(define-key helm-find-files-map (kbd "<tab>")         'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "C-<backspace>") 'helm-find-files-up-one-level)

;;; Make `helm-mini' almighty.
(require 'helm-bookmark)
(setq helm-mini-default-sources `(helm-source-buffers-list
                                  helm-source-recentf
                                  ,(when (boundp 'helm-source-ls-git) 'helm-source-ls-git)
                                  helm-source-bookmarks
                                  helm-source-bookmark-set
                                  helm-source-buffer-not-found))

;;; Eshell
(defun danh/helm/eshell-set-keys ()
  (define-key eshell-mode-map [remap eshell-pcomplete] 'helm-esh-pcomplete)
  (danh/define-keys eshell-mode-map
                   "M-p" 'helm-eshell-history
                   "M-s" nil
                   "M-s f" 'helm-eshell-prompts-all))
(add-hook 'eshell-mode-hook 'danh/helm/eshell-set-keys)

;;; Comint
(defun danh/helm/comint-set-keys ()
  (define-key comint-mode-map (kbd "M-p") 'helm-comint-input-ring))

(add-hook 'comint-mode-hook 'danh/helm/comint-set-keys)
(global-set-key [remap execute-extended-command] 'helm-M-x)
(global-set-key [remap find-file] 'helm-find-files)
(global-set-key [remap occur] 'helm-occur)
(global-set-key [remap list-buffers] 'helm-mini)
(global-set-key [remap dabbrev-expand] 'helm-dabbrev)
(global-set-key [remap yank-pop] 'helm-show-kill-ring)
(global-set-key [remap apropos-command] 'helm-apropos)
(global-set-key [remap query-replace-regexp] 'helm-regexp)
(unless (boundp 'completion-in-region-function)
  (define-key
    lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key
    emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))

;;; Use the M-s prefix just like `occur'.
(define-key prog-mode-map (kbd "M-s f") 'helm-semantic-or-imenu)
;;; The text-mode-map binding targets structured text modes like Markdown.
(define-key text-mode-map (kbd "M-s f") 'helm-semantic-or-imenu)
(with-eval-after-load 'org
  (require 'helm-org-contacts nil t)
  (define-key org-mode-map (kbd "M-s f") 'helm-org-in-buffer-headings))
(with-eval-after-load 'woman
  (define-key woman-mode-map (kbd "M-s f") 'helm-imenu))
(with-eval-after-load 'man
  (define-key Man-mode-map (kbd "M-s f") 'helm-imenu))

(setq helm-source-names-using-follow '("Occur" "Git-Grep" "AG" "mark-ring" "Org Headings" "Imenu"))

;;; From https://www.reddit.com/r/emacs/comments/5q922h/removing_dot_files_in_helmfindfiles_menu/.
(defun danh/helm-skip-dots (old-func &rest args)
  "Skip . and .. initially in helm-find-files.  First call OLD-FUNC with ARGS."
  (apply old-func args)
  (let ((sel (helm-get-selection)))
    (if (and (stringp sel) (string-match "/\\.$" sel))
        (helm-next-line 2)))
  (let ((sel (helm-get-selection))) ; if we reached .. move back
    (if (and (stringp sel) (string-match "/\\.\\.$" sel))
        (helm-previous-line 1))))
(advice-add #'helm-preselect :around #'danh/helm-skip-dots)
(advice-add #'helm-ff-move-to-first-real-candidate :around #'danh/helm-skip-dots)

(with-eval-after-load 'desktop
  (add-to-list 'desktop-globals-to-save 'kmacro-ring)
  (add-to-list 'desktop-globals-to-save 'last-kbd-macro)
  (add-to-list 'desktop-globals-to-save 'kmacro-counter)
  (add-to-list 'desktop-globals-to-save 'kmacro-counter-format)
  (add-to-list 'desktop-globals-to-save 'helm-ff-history))

(helm-top-poll-mode)

;;; Fallback on 'find' if 'locate' is not available.
(unless (executable-find "locate")
  (setq helm-locate-recursive-dirs-command "find %s -type d -regex .*%s.*$"))

;;; Convenience.
(defun danh/helm-toggle-visible-mark-backwards (arg)
  (interactive "p")
  (helm-toggle-visible-mark (- arg)))
(define-key helm-map (kbd "S-SPC") 'danh/helm-toggle-visible-mark-backwards)

(global-set-key  (kbd "C-<f4>") 'helm-execute-kmacro)

(provide 'danh-init-helm)
