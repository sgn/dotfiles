;;;; mu4e

(when (require 'mu4e-maildirs-extension nil t)
  (mu4e-maildirs-extension))
;; prefer plaintext over html email, won't load shr
;; I used to press tab
(require 'shr)
(setq shr-width 80
      shr-use-colors nil
      )

;; (when (not (bound-and-true-p danh/default-user-mail-address))
  ;; (setq danh/default-user-mail-address user-mail-address))
(defvar danh/default-user-mail-address
  user-mail-address
  "default email address")

(defun danh/mu4e-mail-from-maildir (msg)
  "Take email from the maildir.
This works with my particular setup since that's how I named my folder"
  (if (not msg)
      danh/default-user-mail-address
    (let ((maildir (cadr (split-string (mu4e-message-field msg :maildir) "/"))))
      (if (string-match-p "@" maildir)
          maildir
        danh/default-user-mail-address))))

(defun danh/mu4e-sent-folder (msg)
  (format "/%s/Sent" (danh/mu4e-mail-from-maildir msg)))
(defun danh/mu4e-trash-folder (msg)
  (format "/%s/Trash" (danh/mu4e-mail-from-maildir msg)))
(defun danh/mu4e-drafts-folder (msg)
  (format "/%s/Drafts" (danh/mu4e-mail-from-maildir msg)))

(setq
 ;;; mail storage
 mu4e-maildir "~/.cache/maildir"
 mu4e-sent-folder   'danh/mu4e-sent-folder
 mu4e-trash-folder  'danh/mu4e-trash-folder
 mu4e-drafts-folder 'danh/mu4e-drafts-folder
 mu4e-refile-folder "/archives"
 ;;; speed up index
 mu4e-index-cleanup nil
 mu4e-index-lazy-check t
 ;;; fetch mail
 mu4e-get-mail-command "mbsync -a"
 mu4e-update-interval 90
 mu4e-headers-auto-update nil
 mu4e-change-filenames-when-moving t

 ;;; compose mail
 ;; Don't keep sent e-mail buffer.
 message-kill-buffer-on-exit t
 message-send-mail-function 'message-send-mail-with-sendmail
 sendmail-program "/usr/bin/msmtp"
 ;; message-send-mail-function 'smtpmail-multi-send-it
 message-sendmail-envelope-from 'header
 mail-user-agent 'mu4e-user-agent
 message-user-fqdn "congdanhqx.xyz" mu4e-compose-dont-reply-to-self t
 mu4e-compose-hidden-headers nil
 message-citation-line-function 'message-insert-formatted-citation-line
 message-citation-line-format "On %a, %b %d %Y, %N wrote:\n"

 ;;; view mail
 mu4e-headers-date-format "%F"
 mu4e-headers-fields '((:human-date . 10)
                       (:flags . 5)
                       ;; (:size . 6)
                       (:mailing-list . 20)
                       (:from-or-to . 22)
                       (:thread-subject))
 mu4e-headers-time-format "%R"
 mu4e-view-show-addresses t
 mu4e-view-show-images nil
 mu4e-view-image-max-width 800
 mu4e-hide-index-messages t
 mu4e-use-fancy-chars nil
 mu4e-headers-include-related t
 mu4e-headers-from-or-to-prefix '("" . "D =>")
 mu4e-view-date-format "%a %e %b %Y %H:%M:%S %Z"
 mu4e-view-fill-headers nil
 mu4e-view-fields '(
                    :subject
                    :from
                    :to
                    :cc
                    :date
                    :mailing-list
                    :maildir
                    :tags
                    :attachments
                    :signature
                    :decryption
                    :flags
                    :message-id
                    :in-reply-to
                    :path
                    :size
                    :decryption
                    )
 mu4e-header-info-custom
   '((:in-reply-to
      .
      (:name "In-Reply-To"
       :shortname "I-R-T"
       :help "List of Message-Id's this message is in reply to"
       :function
       (lambda (msg)
         (mu4e-message-field msg :in-reply-to)))))
 ;; always prefer plaintext to html
 mu4e-view-html-plaintext-ratio-heuristic most-positive-fixnum
 mu4e-view-prefer-html nil
 ;;; attachment
 mu4e-attachment-dir "~/tmp"
 mu4e-save-multiple-attachments-without-asking t
 mu4e~log-max-lines 10000
 ;; completion
 mu4e-completing-read-function 'completing-read
 ;; encryption
 mml-secure-openpgp-encrypt-to-self t)

(setq mu4e-user-mail-address-list
      '("congdanhqx@gmail.com"
        "congdanhqx@live.com"
        "kungdein@gmail.com"
        "sgn.danh@gmail.com"))

;;; Press "aV" to view in browser.
(add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)

(set-face-foreground 'mu4e-unread-face "yellow")
(set-face-attribute 'mu4e-flagged-face nil :inherit 'font-lock-warning-face)

(when (require 'helm-mu nil t)
  (dolist (map (list mu4e-headers-mode-map mu4e-main-mode-map mu4e-view-mode-map))
    (define-key map "s" 'helm-mu)))

(defun danh/mu4e-set-from-address ()
  "Set from header based on the original maildir"
  (setq user-mail-address
        (danh/mu4e-mail-from-maildir mu4e-compose-parent-message)))
(add-hook 'mu4e-compose-pre-hook 'danh/mu4e-set-from-address)
(add-hook 'mu4e-compose-mode-hook 'flyspell-mode)

(add-hook 'mu4e-view-mode-hook 'mu4e-view-fill-long-lines)

(defun danh/mu4e-kill-ring-save-message-id (&optional msg)
  "Save MSG's \"message-id\" field to the kill-ring.
If MSG is nil, use message at point."
  (interactive)
  (kill-new (mu4e-message-field (or msg (mu4e-message-at-point)) :message-id)))

(setq danh/mu4e-maildir-shortcuts-common
      '(("/congdanhqx@gmail.com/Inbox"   . ?m)
        ("/congdanhqx@gmail.com/Drafts" . ?d)
        ("/sgn.danh@gmail.com/Inbox" . ?g)
        ("/congdanhqx@live.com/Inbox" . ?l)))
(setq mu4e-maildir-shortcuts
      (append danh/mu4e-maildir-shortcuts-common
              '(("/congdanhqx@gmail.com/Sent" . ?s)
                ("/congdanhqx@gmail.com/Trash" . ?t))))

(provide 'danh-init-mu4e)
