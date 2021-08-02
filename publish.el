(require 'ox-publish)

(setq org-export-allow-bind-keywords t)

;; Don't use inline CSS for source code
(setq org-html-htmlize-output-type "css")

(setq org-html-postamble "<p>Copyright &copy; 2001-2021 Stig Brautaset</p>")

(setq org-html-footnotes-section "<div id=\"footnotes\"><hr/><!--%s-->%s</div>")

(setq org-html-format-drawer-function
      (lambda (name content)
	(format "<div class=\"drawer %s\"><h6>%s</h6>%s</div>"
		(downcase name)
		(capitalize name)
		content)))

(setq org-html-home/up-format "
<div id=\"org-div-home-and-up\">
  <nav>
    <a accesskey=\"h\" href=\"%s\">Home</a>
    |
    <a accesskey=\"a\" href=\"%s\">About</a>
  </nav>
</div>
")

(setq org-html-head
      (with-temp-buffer
	(insert-file-contents "templates/head.html")
	(goto-char (point-max))
	(insert org-html-style-default)
	(goto-char (point-max))
	(insert "<style type=\"text/css\">\n")
	(insert-file-contents "style.css")
	(goto-char (point-max))
	(insert "</style>\n")
	(buffer-substring-no-properties
	 (point-min)
	 (point-max))))

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
	 :components ("static" "pages" "articles" "rss"))

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
	 :html-link-up "index.html"
	 :html-link-home "about.html"
	 :publishing-directory "~/blog/_site"
	 :publishing-function org-html-publish-to-html)

	("articles"
	 ,@common-properties
	 :base-directory "~/blog/content/articles"
	 :html-link-up "../../index.html"
	 :html-link-home "../../about.html"
	 :html-head-extra ,(sb/html-head-extra "../../")
	 :publishing-directory "~/blog/_site/articles"
	 :publishing-function org-html-publish-to-html
	 :recursive t)

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
