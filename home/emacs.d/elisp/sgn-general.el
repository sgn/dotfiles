;;;; General Configuration

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

;;; No blinking cursor
(setq visible-cursor nil)
(blink-cursor-mode -1)

;;;; Autosave/Backup
;;; Remember last cursor position
(save-place-mode)
(setq recentf-max-saved-items 40)

;;; backup everything in 1 place
(setq sgn/emacs-temp-file-dir
      (expand-file-name (format "emacs.%s" (user-uid))
                        temporary-file-directory))
(make-directory sgn/emacs-temp-file-dir t)
(chmod sgn/emacs-temp-file-dir #o700)
(setq backup-directory-alist `(("." . ,sgn/emacs-temp-file-dir)))
(setq undo-tree-history-directory-alist
      `(("." . ,sgn/emacs-temp-file-dir)))

;;; answering y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;;;; Visualization
;; Buffer size
(size-indication-mode 1)
;; which function whose this loc
(which-function-mode)

(defun sgn/define-keys (map &rest bindings)
  "Like `define-key' but for several bindings"
  (while bindings
    (let ((key (pop bindings))
          (def (pop bindings)))
      (define-key map (kbd key) def))))

(defun sgn/local-set-keys (&rest bindings)
  "Multiple version of `local-set-key'"
  (while bindings
    (let ((key (pop bindings))
          (def (pop bindings)))
      (local-set-key (kbd key) def))))

(defun sgn/global-set-keys (&rest bindings)
  "Multiple version of `global-set-key'"
  (while bindings
    (let ((key (pop bindings))
          (def (pop bindings)))
      (global-set-key (kbd key) def))))

(defun sgn/tabify-leading ()
  "call `tabify' on leading spaces only.
Works on whole buffer if region is inactive"
  (interactive)
  (require 'tabify)
  (let ((tabify-regexp-old tabify-regexp) start end)
    (if (use-region-p)
      (setq start (region-beginning)
            end (region-end))
      (setq start (point-min)
            end (point-max)))
    (unwind-protect
      (progn (setq tabify-regexp "^\t* [ \t]+")
             (tabify start end))
      (setq tabify-regexp tabify-regexp-old))))

(defun sgn/turn-off-indent-tabs ()
  "turn of tab indentation unconditionally"
  (setq indent-tabs-mode nil))

(defun sgn/turn-on-indent-tabs ()
  "turn on tab indentation unconditionally"
  (setq indent-tabs-mode t))

(defun sgn/local-turn-off-backup ()
  "turn off backup for local buffer."
  (set (make-local-variable 'backup-inhibited) t))

(defun sgn/prettify ()
  "(un)-tabify, indent and delete trailing whitespace.

tabify if `indent-tabs-mode' is true, otherwise untabify.
Work on buffer and region"
  (interactive)
  (let ((start
          (set-marker (make-marker)
                      (if (use-region-p) (region-beginning) (point-min))))
        (end
          (set-marker (make-marker)
                      (if (use-region-p) (region-end) (point-max)))))
    (if indent-tabs-mode
      (sgn/tabify-leading)
      (untabify start end))
    (indent-region start end)
    (save-restriction
      (narrow-to-region start end)
      (delete-trailing-whitespace))))

(defun sgn/reset-fill-column ()
  "reset `fill-column' to its default value"
  (setq fill-column (default-value 'fill-column)))

;;; Line numbers
;;; Adding to `find-file-hook' ensures it will work for every file,
;;; regardless of the mode,
;;; but it won't work for buffers without files nor on mode change.
(defun sgn/turn-on-local-column-number-mode ()
  "turn on `column-number-mode' for this buffer"
  (set (make-local-variable 'column-number-mode) t))
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook 'sgn/turn-on-local-column-number-mode))

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(size-indication-mode -1)

;;;; Scrolling
(setq scroll-error-top-bottom t)
;;; line by line
(setq scroll-step 1)

;;;; Indentation
(setq-default tab-width 8)
(defvaralias 'standard-indent 'tab-width)
(setq-default indent-tabs-mode t)
(sgn/global-set-keys "<f11>" 'electric-indent-local-mode)

;;; `just-one-space' is more or less single call of `cycle-spacing'
(global-set-key [remap just-one-space] 'cycle-spacing)

;;;; Abbrev expansion
(sgn/global-set-keys "C-SPC" 'dabbrev-completion
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

(setq delete-by-moving-to-trash t)
(save-place-mode t)

;;;; Browse url at point
(require 'browse-url)
(global-set-key (kbd "C-<return>") 'browse-url)
(when (fboundp 'w3m-browse-url)
  (setq w3m-fill-column fill-column)
  (setq browse-url-browser-function 'w3m-browse-url))

;;;; Spelling
;;; ispell
(setq ispell-dictionary "english")
(sgn/define-keys text-mode-map
                 "C-<f6>" 'ispell-change-dictionary
                 "<f6>" 'ispell-buffer)
;;; matching parenthesis without delay
(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-when-point-inside-paren t)
;;; autopair's author recommended to use electric-pair
;; (electric-pair-mode)

;;;; Calendar
(setq calendar-date-style 'iso)

;;;; Code compilation
;; Save without asking before compilation
(setq compilation-ask-about-save nil
      compilation-scroll-output 'first-error)
(with-eval-after-load 'compile
  (make-variable-buffer-local 'compile-command))
;; Some command output color escape regardless dumb terminal
;; (require 'ansi-color)

(defun sgn/compilation-colourise-buffer ()
  (when (eq major-mode 'compilation-mode)
    (ansi-color-apply-on-region compilation-filter-start (point-max))))
(add-hook 'compilation-filter-hook 'sgn/compilation-colourise-buffer)
(sgn/global-set-keys "<C-f8>" 'previous-error
                     "<f8>" 'next-error)

;; recall compile
(defun sgn/run-last-compile-command ()
  (interactive)
  (compile compile-command))
(sgn/define-keys prog-mode-map
                 "C-<f6>" 'compile
                 "<f6>" 'sgn/run-last-compile-command)

;;;; Buffer names.
(setq uniquify-buffer-name-style 'forward)

;;;; Clipboard
(setq
 ;; select-enable-primary t
 save-interprogram-paste-before-kill t)

;;;; Text Scaling
(global-unset-key (kbd "C-<down-mouse-1>"))
(sgn/global-set-keys "C--" 'text-scale-decrease
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

;;; Support for Emacs pinentry.
;;; Required for eshell/sudo and everything relying on GPG queries.
; (setq epa-pinentry-mode 'loopback)
; (when (require 'pinentry nil t)
;   (setenv "INSIDE_EMACS" (format "%s,comint" emacs-version))
;   (pinentry-start))

(setq woman-fill-column fill-column)

(defun sgn/escape-region (&optional regex to-string)
  "Escape double-quote and backslashes.
This is useful for writing Elisp strings that contains those characters.
Optional parameters let you control the replacement of `regex' for `to-string'"
  (interactive)
  (unless regex (setq regex "\\([\"\\\\]\\)"))  ; \(["\\]\)
  (unless to-string (setq to-string "\\\\\\1")) ; \\\1
  (while (re-search-forward regex (if (use-region-p) (region-end) (point-max)) t)
    (replace-match to-string)))
(global-set-key (kbd "M-\\") 'sgn/escape-region)

;; https://stackoverflow.com/questions/17829619/
(defun sgn/rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))
(global-set-key (kbd "C-c r")  'sgn/rename-file-and-buffer)

;;; Save all visited URLs.
(setq url-history-track t
      url-history-file (expand-file-name "url_hist" user-emacs-directory))

(setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))
(setq require-final-newline t)

(provide 'sgn-general)

; general.el ends here
