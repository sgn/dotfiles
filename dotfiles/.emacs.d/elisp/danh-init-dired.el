;;;; Dired initialisation

(defun danh/dired-toggle-mark-current ()
  "unmark the marked file and vice versus"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((inhibit-read-only t))
      (apply 'subst-char-in-region
             (point) (1+ (point))
             (if (eq ?\040 (following-char))
                 (list ?\040 dired-marker-char)
               (list dired-marker-char ?\040))))))

(danh/define-keys dired-mode-map
                 "SPC" 'danh/dired-toggle-mark-current
                 "<right>" 'dired-find-file
                 "<left>" 'dired-up-directory
                 "<backspace>" 'dired-up-directory
                 "b" 'dired-up-directory)
(when (fboundp 'evil-collection-define-key)
  (evil-collection-define-key 'normal 'dired-mode-map
                              (kbd "SPC") 'danh/dired-toggle-mark-current
                              (kbd "<right>") 'dired-find-file
                              (kbd "<left>") 'dired-up-directory
                              (kbd "<backspace>") 'dired-up-directory
                              "b" 'dired-up-directory))

(setq dired-listing-switches "--group-directories-first -lha")

(require 'dired-x)
(setq dired-omit-files "^\\.")

(setq dired-guess-shell-alist-user
      (list
       '("\\.\\(jpe?g\\|png\\|git\\)$" "sxiv")
       '("\\.\\(mkv\\|mpe?g\\|avi\\|mp4\\|ogg\\|ogm\\)$" "mpv")))

(when (executable-find "sxiv")
  (setq image-dired-external-viewer "sxiv"))

(provide 'danh-init-dired)

; danh-init-dired.el ends here
