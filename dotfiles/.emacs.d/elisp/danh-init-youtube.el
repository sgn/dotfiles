;; https://www.reddit.com/r/emacs/comments/9i8q97/emacs_more_protips/e6hyt1s/
;;;###autoload
(defun danh/online-video-downloader ()
  "Download video using  url from clipboard.
TODO: Choose video format with universal argument (C-u): no argument = no format set,
m = mp4 and w = webm | GPLv3"
  (interactive)
  (let* ((online-video-dl-command "youtube-dl -o ~/") ;; -o to save in a different folder
	 (folder "Videos") ;; default folder TODO: choose folder and check if it exist, create one if not.
	 (video-filename "/'%(title)s-%(id)s.%(ext)s'") ;; Video name
	 (format " -f ") ;; format of the video. TODO: no format
	 (format-number " 302")
	 (online-video-url (current-kill 0 t))) ;; retrieves url from clipboard into online-video-url
    ;; Assemble everything and run as async shell command. Another buffer will open to show download progress!
    (async-shell-command (concat online-video-dl-command folder video-filename format format-number " " online-video-url))))

;;;###autoload
(defun danh/online-video-to-audio-downloader ()
  "Download audio using url from clipboard.
TODO: Choose audio format with universal argument (C-u): no argument = no format set,
		    f = flac, o = ogg and m = mp3 | GPLv3"
  (interactive)
  (let* ((online-video-dl-command "youtube-dl -o ~/") ;; -o to save in a different folder
	 (folder "Music") ;; default folder TODO: choose folder and check if it exist, create one if not.
	 (video-filename "/'%(title)s-%(id)s.%(ext)s'") ;; Video name
	 (format "-x --audio-format") ;; format of the video. TODO: no format
	 (format-extension "flac")
	 (online-video-url (current-kill 0 t))) ;; retrieves url from clipboard into online-video-url
    ;; Assemble everything and run as async shell command. Another buffer will open to show download progress!
    (async-shell-command (concat online-video-dl-command folder video-filename " " format " " format-extension " " online-video-url))))

;;;###autoload
(defun danh/online-to-video-player ()
  "Open open url of the video with url from clipboard | GPLv3"
  (interactive)
  (let* ((video-player-command "mpv") ;; set video-player-command to mpv
	 (online-video-url (current-kill 0 t))) ;; retrieves url from clipboard into online-video-url
    ;; Assemble everything and run as sub-process.
    (start-process-shell-command (concat video-player-command " " online-video-url) nil (concat video-player-command " " online-video-url))
    (message "Opening online video with %s in an instant!" video-player-command)))

(provide 'danh-init-youtube)
