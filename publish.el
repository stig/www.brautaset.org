;; Where to put installed packages
(setq package-user-dir "~/blog/elpa")

;; Turn off backup-files for my blog-publishing
(setq make-backup-files nil)

(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-refresh-contents)

(setq package-selected-packages
      '(org-plus-contrib
	htmlize
	clojure-mode
	scala-mode))

;; Install packages
(mapc (lambda (p)
	(unless (package-installed-p p)
	  (package-install p)))
      package-selected-packages)

(require 'org)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t)))

(require 'ox-publish)
(require 'ox-rss)

;; Utility function used to pull in templates
(defun slurp (path)
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-substring-no-properties
     (point-min)
     (point-max))))

(setq org-export-allow-bind-keywords t)

;; Don't use inline CSS for source code
(setq org-html-htmlize-output-type "css")

;; Pages get this
(setq org-html-postamble (format-time-string (slurp "templates/postamble.html")))

;; Posts get this format
(setq org-html-postamble-format `(("en" ,(slurp "templates/post_postamble.html"))))

(setq org-html-footnotes-section "<div id=\"footnotes\"><hr/><!--%s-->%s</div>")

(setq org-html-format-drawer-function
      (lambda (name content)
	(format "<div class=\"drawer %s\"><h6>%s</h6>%s</div>"
		(downcase name)
		(capitalize name)
		content)))

(setq nav-template (slurp "templates/nav.html"))
(setq org-html-preamble
      (lambda (props)
	(let ((path (plist-get props :nav-at)))
	  (format nav-template path path path path))))

(setq org-html-head
      (concat (slurp "templates/head.html")
	      org-html-style-default
	      "<style type=\"text/css\">\n"
	      (slurp "style.css")
	      "</style>\n"))

(defun sb/html-head-extra (prefix)
  (format "<link rel=\"icon\" type=\"image/png\" href=\"%sicon.png\" />\n" prefix))

(setq common-properties
      '(:author "Stig Brautaset"
	:email "stig@brautaset.org"

	:section-numbers nil
	:time-stamp-file nil
	:with-drawers t
	:with-toc nil

	:html-doctype "html5"
	:html-head-include-default-style nil
	:html-head-include-scripts nil
        :html-metadata-timestamp-format "%e %B %Y"))

(setq org-publish-project-alist
      `(("www"
	 :components ("static" "pages" "posts"))

	("static"
	 :base-directory "~/blog/content"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :publishing-directory "~/blog/_site"
	 :recursive t
	 :publishing-function org-publish-attachment)

        ("pages"
	 ,@common-properties
	 :base-directory "~/blog/content"
         :exclude "feed.org"
	 :html-head-extra ,(sb/html-head-extra "")
	 :nav-at ""
	 :publishing-directory "~/blog/_site"
	 :publishing-function org-html-publish-to-html)

        ("posts"
	 ,@common-properties
	 :base-directory "~/blog/content/posts"
         :nav-at "../"
	 :html-head-extra ,(sb/html-head-extra "../")
	 :html-postamble t
	 :publishing-directory "~/blog/_site/posts"
	 :publishing-function org-html-publish-to-html)

	("rss"
	 ,@common-properties
	 :base-directory "~/blog/content"
	 :exclude ".*"
	 :html-link-home "https://www.brautaset.org"
	 :html-link-use-abs-url t
	 :include ("feed.org")
	 :publishing-directory "~/blog/_site"
	 :publishing-function (org-rss-publish-to-rss)
	 :rss-image-url "https://www.brautaset.org/icon.png"
	 :rss-extension "xml")))

;; Turn off a harmless (but annoying) warning during publication.
;; ("Can't guess python-indent-offset, using defaults 4")
(setq python-indent-guess-indent-offset-verbose nil)
