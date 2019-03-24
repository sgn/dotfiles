(require 'sendmail)

(require 'mm-view)
(setcdr (assoc 'lynx mm-text-html-renderer-alist)
        '(mm-inline-render-with-stdin
          nil
          "lynx"
          "-force_html"
          "-stdin" "-assume_charset=utf-8"
          "-dump" "-display_charset=utf-8"))

(defvar danh/mm-insert-inline-use-utf-8 nil)
(defadvice mm-insert-inline (around mm-insert-inline-utf-8)
  (let ((x (point)))
    (prog1 (progn ad-do-it)
      (when danh/mm-insert-inline-use-utf-8
        (decode-coding-region x (point-max) 'utf-8)))))
(ad-activate 'mm-insert-inline)
(defadvice mm-inline-text-html (around mm-inline-text-html-utf-8)
  (let ((danh/mm-insert-inline-use-utf-8 t))
    ad-do-it))
(ad-activate 'mm-inline-text-html)

(setq
 message-kill-buffer-on-exit t
 message-sendmail-envelope-from 'header
 message-send-mail-function 'message-send-mail-with-sendmail
 sendmail-program "/usr/bin/msmtp"
 message-user-fqdn "congdanhqx.xyz"
 mm-text-html-renderer 'lynx
 notmuch-saved-searches
 (quote
  ((:name "today"
          :query "date:1days.. AND (path:/congdanhqx/ or to:/sgn.danh/)"
          :key "t")
   (:name "following"
          :query "tag:follow"
          :key "f")
   (:name "inbox"
          :query "tag:inbox"
          :key "i")
   (:name "unread"
          :query "tag:unread"
          :key "u")
   (:name "to me"
          :query "(to:congdanhqx@gmail.com or to:congdanhqx@live.com)"
          :key "m")
   (:name "this week"
          :query "date:7days.. AND (path:/congdanhqx/ or to:/sgn.danh/)"
          :key "w")
   (:name "mailing list this week"
          :query "tag:lists AND date:7days.."
          :key "l")))
 notmuch-message-headers (quote
                          ("Subject"
                           "To"
                           "Cc"
                           "Date"
                           "Id"
                           "Message-Id"
                           "In-Reply-To"
                           "List-Id"
                           "Content-Type")))

(defun notmuch ()
  (interactive)
  (notmuch-search (plist-get (first notmuch-saved-searches) :query)))

(defun danh/notmuch-show-toggle-follow ()
  "Toggle follow tag for message"
  (interactive)
  (if (member "follow" (notmuch-show-get-tags))
      (notmuch-show-tag (list "-follow"))
    (notmuch-show-tag (list "+follow"))))

(defun danh/notmuch-search-toggle-follow ()
  "Toggle follow tag for message"
  (interactive)
  (if (member "follow" (notmuch-search-get-tags))
      (notmuch-search-tag (list "-follow"))
    (notmuch-search-tag (list "+follow"))))

(defun danh/notmuch-tree-toggle-follow ()
  "Toggle follow tag for message"
  (interactive)
  (if (member "follow" (notmuch-tree-get-tags))
      (notmuch-tree-tag (list "-follow"))
    (notmuch-tree-tag (list "+follow"))))

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
    "f" 'danh/notmuch-show-toggle-follow
    "r" 'notmuch-show-reply
    "R" 'notmuch-show-reply-sender)
  (evil-collection-define-key 'normal 'notmuch-tree-mode-map
    "f" 'danh/notmuch-tree-toggle-follow
    "r" (notmuch-tree-close-message-pane-and 'notmuch-show-reply)
    "R" (notmuch-tree-close-message-pane-and 'notmuch-show-reply-sender))
  (evil-collection-define-key 'normal 'notmuch-search-mode-map
    "f" 'danh/notmuch-search-toggle-follow
    "r" 'notmuch-search-reply-to-thread
    "R" 'notmuch-search-reply-to-thread-sender))
