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
    <a accesskey=\"H\" href=\"%s\">About</a>
  </nav>
</div>
")

(setq org-html-head
      (with-temp-buffer
	(insert "<style type=\"text/css\">\n")
	(insert-file-contents "style.css")
	(goto-char (point-max))
	(insert "</style>\n")
	(buffer-substring-no-properties
	 (point-min)
	 (point-max))))

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
	 :components ("www-pages" "www-articles" "www-rss"))

        ("www-pages"
	 ,@common-properties
	 :base-directory "~/blog"
         :exclude ".*"
	 :html-link-up "index.html"
	 :html-link-home "about.html"
	 :include ("index.org" "articles.org" "about.org" "style-demo.org")
	 :publishing-directory "~/blog"
	 :publishing-function org-html-publish-to-html)

	("www-articles"
	 ,@common-properties
	 :base-directory "~/blog/articles"
	 :html-link-up "../../index.html"
	 :html-link-home "../../about.html"
	 :publishing-directory "~/blog/articles"
	 :publishing-function org-html-publish-to-html
	 :recursive t)

	("www-rss"
	 ,@common-properties
	 :base-directory "~/blog"
	 :exclude ".*"
	 :html-link-home "https://www.brautaset.org"
	 :html-link-use-abs-url t
	 :include ("feed.org")
	 :publishing-directory "~/blog"
	 :publishing-function (org-rss-publish-to-rss)
	 :rss-image-url "https://www.brautaset.org/icon.png"
	 :rss-extension "xml")))

;; Turn off a harmless (but annoying) warning during publication.
;; ("Can't guess python-indent-offset, using defaults 4")
(setq python-indent-guess-indent-offset-verbose nil)
