;;;; Core initialization

(require 'danh-functions)

;;;; Minimal UI
;;; No splash, menu/tool/scroll bar
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
;;; `tool-bar-mode' and `scroll-bar-mode' is optional
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;;; Force minibuffer
(setq use-dialog-box nil)
(setq echo-keystrokes 0.5)

;;;; Autosave/Backup
;;; Remember last cursor position
(save-place-mode)
(setq recentf-max-saved-items 40)
;;; backup everything in 1 place
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory))))

;;;; Keyboard/Command
;;; Disable suspend hotkey
;; (global-unset-key (kbd "C-x C-z"))
;;; answering y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;;;; Visualization
;; Buffer size
(size-indication-mode 1)
;; which function whose this loc
(which-function-mode)

;;; Line numbers
;;; Adding to `find-file-hook' ensures it will work for every file, regardless of
;;; the mode, but it won't work for buffers without files nor on mode change.
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook 'danh/turn-on-local-column-number-mode)
  (add-hook hook 'display-line-numbers-mode))
(setq display-line-numbers-type 'visual)

(setq kill-whole-line t)
;;;; Scrolling
(setq scroll-error-top-bottom t)
;;; line by line
(setq scroll-step 1)

;;;; Indentation
(setq-default tab-width 8)
(defvaralias 'standard-indent 'tab-width)
(setq-default indent-tabs-mode t)

;;; `just-one-space' is more or less single call of `cycle-spacing'
(global-set-key [remap just-one-space] 'cycle-spacing)

;;;; Abbrev expansion
(danh/global-set-keys "C-SPC" 'dabbrev-completion
                     ;; "M-/" 'hippie-expand
                     "C-<tab>" 'dabbrev-expand)
;; (add-hook 'text-mode-hook 'abbrev-mode)

;;;; Auto Fill 80
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Increase `split-width-threshold' in order to use the current splitting for
;; error on compiling.
;; Source: Reddit
(setq split-height-threshold nil
      split-width-threshold 160)

;;;; Window
(danh/global-set-keys
 ;; windmove
 "S-<left>" 'windmove-left
 "s-h" 'windmove-left                    ; conflict with wm?
 "S-<right>" 'windmove-right
 "s-l" 'windmove-right                   ; conflict with wm?
 "S-<up>" 'windmove-up
 "s-k" 'windmove-up                      ; conflict with wm?
 "S-<down>" 'windmove-down
 "s-j" 'windmove-down                    ; conflict with wm?
 "s-o" 'other-window
 ;; win resize
 "s--" 'shrink-window-horizontally
 "s-H" 'shrink-window-horizontally
 "s-+" 'enlarge-window-horizontally
 "s-=" 'enlarge-window-horizontally
 "s-L" 'enlarge-window-horizontally
 "s-J" 'shrink-window
 "s-K" 'enlarge-window
 ;; Delete Windows
 "s-d" 'delete-window                    ; conflict with wm
 "s-S-d" 'delete-other-windows)

;;;; Browse url at point
(require 'browse-url)
(global-set-key (kbd "C-<return>") 'browse-url)
(when (require 'w3m nil t)
  (setq browse-url-browser-function 'w3m-browse-url))

;;;; Spelling
;;; ispell
(setq ispell-dictionary "english")
(danh/define-keys text-mode-map
                 "C-<f6>" 'ispell-change-dictionary
                 "<f6>" 'ispell-buffer)
;;; matching parenthesis without delay
(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-when-point-inside-paren t)
;;; autopair's author recommended to use electric-pair
(electric-pair-mode)

;;;; Calendar
(setq calendar-week-start-day 1
      calendar-date-style 'iso)

;;;; Code compilation
;; Save without asking before compilation
(setq compilation-ask-about-save nil
      compilation-scroll-output 'first-error)
(with-eval-after-load 'compile
  (make-variable-buffer-local 'compile-command))
;; Some command output color escape regardless dumb terminal
(require 'ansi-color)
(defun danh/compilation-colourise-buffer ()
  (when (eq major-mode 'compilation-mode)
    (ansi-color-apply-on-region compilation-filter-start (point-max))))
(add-hook 'compilation-filter-hook 'danh/compilation-colourise-buffer)
(danh/global-set-keys "<f7>" 'previous-error
                     "<f8>" 'next-error)

;; recall compile
(defun danh/run-last-compile-command ()
  (interactive)
  (compile compile-command))
(danh/define-keys prog-mode-map
                 "C-<f6>" 'compile
                 "<f6>" 'danh/run-last-compile-command)

;;;; Buffer names.
(setq uniquify-buffer-name-style 'forward)

;;;; Clipboard
(setq select-enable-primary t
      save-interprogram-paste-before-kill t)

;;;; Text Scaling
(global-unset-key (kbd "C-<down-mouse-1>"))
(danh/global-set-keys "C--" 'text-scale-decrease
                     "C-+" 'text-scale-increase
                     "C-=" 'text-scale-increase
                     "C-<mouse-5>" 'text-scale-decrease
                     "C-<mouse-4>" 'text-scale-increase)

;;;; Comment
;;; `comment-dwim' -> `comment-line'
(global-set-key (kbd "M-;") 'comment-line)
;;; Always comment empty line
(setq comment-empty-lines 'eol)

;;; `kill-buffer' -> `kill-this-buffer'
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;;;; Ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

(let ((fortune (danh/fortune-scratch-message)))
  (when fortune
    (setq initial-scratch-message fortune)))

;;; Support for Emacs pinentry.
;;; Required for eshell/sudo and everything relying on GPG queries.
(setq epa-pinentry-mode 'loopback)
(when (require 'pinentry nil t)
  (setenv "INSIDE_EMACS" (format "%s,comint" emacs-version))
  (pinentry-start))

;;; Make windowing more reactive on.  This is especially true with Helm on EXWM.
(setq x-wait-for-event-timeout nil)
(defalias 'woman-fill-column 'fill-column)

;;; Save all visited URLs.
(setq url-history-track t
      url-history-file (expand-file-name "url_hist" user-emacs-directory))

(setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))
(setq require-final-newline t)

(provide 'danh-core)

; danh-core.el ends here
