;;; danh-functions

(defun danh/define-keys (map &rest bindings)
  "Like `define-key' but for several bindings"
  (while bindings
    (let ((key (pop bindings))
          (def (pop bindings)))
      (define-key map (kbd key) def))))

(defun danh/local-set-keys (&rest bindings)
  "Multiple version of `local-set-key'"
  (while bindings
    (let ((key (pop bindings))
          (def (pop bindings)))
      (local-set-key (kbd key) def))))

(defun danh/global-set-keys (&rest bindings)
  "Multiple version of `global-set-key'"
  (while bindings
    (let ((key (pop bindings))
          (def (pop bindings)))
      (global-set-key (kbd key) def))))

(defun danh/escape-region (&optional regex to-string)
  "Escape double-quote and backslashes.
This is useful for writing Elisp strings that contains those characters.
Optional parameters let you control the replacement of `regex' for `to-string'"
  (interactive)
  (unless regex (setq regex "\\([\"\\\\]\\)"))  ; \(["\\]\)
  (unless to-string (setq to-string "\\\\\\1")) ; \\\1
  (while (re-search-forward regex (if (use-region-p) (region-end) (point-max)) t)
    (replace-match to-string)))
(global-set-key (kbd "M-\\") 'danh/escape-region)

(defun danh/tabify-leading ()
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

(defun danh/prettify ()
  "(un)-tabify, indent and delete trailing whitespace.

tabify if `indent-tabs-mode' is true, otherwise untabify.
Work on buffer and region"
  (interactive)
  (let ((start (set-marker (make-marker)
			   (if (use-region-p) (region-beginning) (point-min))))
	(end (set-marker (make-marker)
			 (if (use-region-p) (region-end) (point-max)))))
    (if indent-tabs-mode
	(danh/tabify-leading)
      (untabify start end))
    (indent-region start end)
    (save-restriction
      (narrow-to-region start end)
      (delete-trailing-whitespace))))

;; https://www.reddit.com/r/emacs/comments/70bn7v/what_do_you_have_emacs_show_when_it_starts_up/
(defun danh/fortune-scratch-message ()
  (interactive)
  (let ((fortune
	 (when (executable-find "fortune")
	   (with-temp-buffer
	     (shell-command "fortune -a" t)
	     (while (not (eobp))
	       (insert ";; ")
	       (forward-line))
	     (delete-trailing-whitespace (point-min) (point-max))
	     (concat (buffer-string) "\n")))))
    (if (called-interactively-p 'any)
        (insert fortune)
      fortune)))

(defun danh/reset-fill-column ()
  "reset `fill-column' to its default value"
  (setq fill-column (default-value 'fill-column)))

(defun danh/shell-last-command ()
  "run last shell command"
  (interactive)
  (let ((last (car shell-command-history)))
    (if last
	(shell-command last)
      (error "Shell command history is empty"))))
(global-set-key (kbd "C-M-!") 'danh/shell-last-command)

(defun danh/sort-unique (arg)
  "sort | uniq on elisp"
  (interactive "P")
  (let ((start (set-marker (make-marker)
			   (if (use-region-p) (region-beginning) (point-min))))
	(end (set-marker (make-marker)
			 (if (use-region-p) (region-end) (point-max))))
	(sort-fold-case (if arg nil t)))
    (delete-trailing-whitespace start end)
    (sort-lines nil start end)
    (delete-duplicate-lines start end)))

(defun danh/turn-on-local-column-number-mode ()
  "turn on `column-number-mode' for this buffer"
  (set (make-local-variable 'column-number-mode) t))

(defun danh/turn-off-indent-tabs ()
  "turn of tab indentation unconditionally"
  (setq indent-tabs-mode nil))

(defun danh/turn-on-indent-tabs ()
  "turn on tab indentation unconditionally"
  (setq indent-tabs-mode t))

(defun danh/local-turn-off-backup ()
  "turn off backup for local buffer.

`newsrc.eld' needs this to speed up its work"
       (set (make-local-variable 'backup-inhibited) t))

;; https://stackoverflow.com/questions/17829619/
(defun danh/rename-file-and-buffer ()
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
(global-set-key (kbd "C-c r")  'danh/rename-file-and-buffer)

;; install the missing packages
(defun danh/install-all-packages ()
  (interactive)
  (when (require 'package nil t)
    (package-refresh-contents)
    (dolist (package package-selected-packages)
      (unless (package-installed-p package)
	(package-install package)))))

(provide 'danh-functions)

; danh-functions.el ends here
