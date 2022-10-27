;; Turn off backup-files for my blog-publishing
(setq make-backup-files nil)

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

;; Pages get these pre/postambles
(setq org-html-preamble (slurp "templates/header.html"))
(setq org-html-postamble (format-time-string (slurp "templates/footer.html")))

;; Posts get these pre/postambles
(setq org-html-preamble-format `(("en" ,(slurp "templates/post_header.html"))))
(setq org-html-postamble-format `(("en" ,(slurp "templates/post_footer.html"))))

(setq org-html-footnotes-section "<div id=\"footnotes\"><hr/><!--%s-->%s</div>")

(setq org-html-head
      (concat (slurp "templates/head.html")
              "<style type=\"text/css\">\n"
	      (slurp "style.css")
	      "</style>\n"))

(defun sb/html-head-extra (prefix)
  (format "<link rel=\"icon\" type=\"image/png\" href=\"%sicon.png\" />\n" prefix))

(setq common-properties
      '(:section-numbers nil
	:time-stamp-file nil
        :with-toc nil
	:with-title nil

	:html-doctype "html5"
	:html-head-include-default-style nil
	:html-head-include-scripts nil
        :html-metadata-timestamp-format "%B %Y"))

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
         :publishing-directory "~/blog/_site"
	 :publishing-function org-html-publish-to-html)

        ("posts"
	 ,@common-properties
	 :base-directory "~/blog/content/posts"
         :html-head-extra ,(sb/html-head-extra "../")
         :html-preamble t
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
	 :publishing-function org-rss-publish-to-rss
	 :rss-image-url "https://www.brautaset.org/icon.png"
	 :rss-extension "xml")))

;; Turn off a harmless (but annoying) warning during publication.
;; ("Can't guess python-indent-offset, using defaults 4")
(setq python-indent-guess-indent-offset-verbose nil)
