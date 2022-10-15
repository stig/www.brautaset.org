(setq user-emacs-directory "~/blog")

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


(straight-use-package 'org)
(straight-use-package '(ox-rss :type git
			       :host gitlab
			       :repo "nsavage/ox-rss"))
(straight-use-package 'org-contrib)
(straight-use-package 'htmlize)
(straight-use-package 'clojure-mode)
(straight-use-package 'scala-mode)
