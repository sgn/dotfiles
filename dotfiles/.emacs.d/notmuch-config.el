(require 'sendmail)

(setq
 message-kill-buffer-on-exit t
 message-sendmail-envelope-from 'header
 message-send-mail-function 'message-send-mail-with-sendmail
 sendmail-program "/usr/bin/msmtp"
 message-user-fqdn "congdanhqx.xyz"
 mm-text-html-renderer 'shr
 notmuch-saved-searches
 (quote
  ((:name "me in 1 day"
          :query "date:1days.. AND (to:congdanhqx@gmail.com OR to:congdanhqx@live.com or to:kungdein@gmail.com or to:sgn.danh@gmail.com)"
          :key "t")
   (:name "inbox"
          :query "tag:inbox"
          :key "i")
   (:name "unread"
          :query "tag:unread"
          :key "u")
   (:name "to me"
          :query "(to:congdanhqx@gmail.com or to:congdanhqx@live.com) AND NOT tag:delete"
          :key "m")
   (:name "me in 7 days"
          :query "date:7days.. AND (to:congdanhqx@gmail.com OR to:congdanhqx@live.com or to:kungdein@gmail.com or to:sgn.danh@gmail.com)"
          :key "w")
   (:name "me at git"
          :query "path:git/** AND (to:congdanhqx@gmail.com OR cc:congdanhqx@gmail.com)"
          :key "g")))
 notmuch-message-headers (quote
                          ("Subject"
                           "To"
                           "Cc"
                           "Date"
                           "Id"
                           "Message-Id"
                           "In-Reply-To"
                           "List-ID"
                           "Content-Type")))

(defun notmuch ()
  (interactive)
  (notmuch-search (cadddr (first notmuch-saved-searches))))

(defun danh/notmuch-tag-todo ()
  (interactive)
  (notmuch-show-tag-message "+todo"))
(defun danh/notmuch-toglle-todo ()
  (interactive)
  (notmuch-show-tag-message "-todo"))

(defun danh/notmuch-append-msg-id-to-scratch ()
  (interactive)
  (let ((msgid (notmuch-show-get-message-id)))
    (if (not msgid)
        (message "Nothing to save")
      (with-current-buffer "*scratch*"
        (forward-line)
        (insert msgid)
        (insert "\n"))
      (message "Saved: %s" msgid))))

(define-key notmuch-show-mode-map "=" 'danh/notmuch-append-msg-id-to-scratch)
(define-key notmuch-show-mode-map "r" 'notmuch-show-reply)
(define-key notmuch-show-mode-map "R" 'notmuch-show-reply-sender)
(define-key notmuch-search-mode-map "r" 'notmuch-search-reply-to-thread)
(define-key notmuch-search-mode-map "R" 'notmuch-search-reply-to-thread-sender)
(define-key notmuch-tree-mode-map "r" (notmuch-tree-close-message-pane-and #'notmuch-show-reply))
(define-key notmuch-tree-mode-map "R" (notmuch-tree-close-message-pane-and #'notmuch-show-reply-sender))

(when (require 'evil-collection-notmuch)
  (evil-collection-notmuch-setup)
  (evil-collection-define-key 'normal 'notmuch-show-mode-map
    (kbd "SPC") 'notmuch-show-advance-and-archive
    "<" 'notmuch-show-toggle-thread-indentation
    "=" 'danh/notmuch-append-msg-id-to-scratch
    "r" 'notmuch-show-reply
    "R" 'notmuch-show-reply-sender)
  (evil-collection-define-key 'normal 'notmuch-tree-mode-map
    "r" (notmuch-tree-close-message-pane-and 'notmuch-show-reply)
    "R" (notmuch-tree-close-message-pane-and 'notmuch-show-reply-sender))
  (evil-collection-define-key 'normal 'notmuch-search-mode-map
    "r" 'notmuch-search-reply-to-thread
    "R" 'notmuch-search-reply-to-thread-sender))