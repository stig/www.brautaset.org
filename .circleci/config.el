;; Don't use inline CSS for source code
(setq org-html-htmlize-output-type "css")

(setq sb/copyright "<p>Copyright &copy; 2001-2020 Stig Brautaset</p>")

(setq org-html-footnotes-section "<div id=\"footnotes\"><hr><!--%s-->%s</div>")

(setq org-html-format-drawer-function
      (lambda (name content)
	(format "<div class=\"drawer %s\"><h6>%s</h6>%s</div>"
		(downcase name)
		(capitalize name)
		content)))

(setq org-html-preamble "
<nav>
  <ul>
    <li><a accesskey=\"H\" href=\"index.html\">Home</a></li>
    <li><a accesskey=\"p\" href=\"publications.html\">Publications</a></li>
    <li><a accesskey=\"A\" href=\"about.html\">About</a></li>
  </ul>
</nav>
")

(setq org-html-postamble (concat "
<nav>
  <ul>
    <li><a accesskey=\"H\" href=\"../../index.html\">Home</a></li>
    <li><a accesskey=\"A\" href=\"../../about.html\">About</a></li>
  </ul>
</nav>
" sb/copyright))

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
	:html-html5-fancy t
	:html-metadata-timestamp-format "%e %B %Y"))

(setq org-publish-project-alist
      `(("www"
	 :components ("www-pages" "www-articles" "www-static" "www-rss"))

	("www-static"
	 ,@common-properties
	 :base-directory "~/blog"
	 :base-extension "css\\|jpg\\|jpeg\\|png\\|pdf\\|html\\|xml"
	 :recursive t
	 :publishing-directory "~/public_html"
	 :publishing-function org-publish-attachment)

	("www-pages"
	 ,@common-properties
	 :base-directory "~/blog"
	 :exclude ".*"
	 :html-postamble (lambda (ignored) sb/copyright) ;; no bottom nav for pages
	 :include ("index.org" "publications.org" "articles.org" "about.org")
	 :publishing-directory "~/public_html"
	 :publishing-function org-html-publish-to-html)

	("www-articles"
	 ,@common-properties
	 :base-directory "~/blog/articles"
	 :html-preamble nil ;; no preamble (top nav!) for articles
	 :publishing-directory "~/public_html/articles"
	 :publishing-function org-html-publish-to-html
	 :recursive t)

	("www-rss"
	 ,@common-properties
	 :base-directory "~/blog"
	 :exclude ".*"
	 :html-link-home "https://www.brautaset.org"
	 :html-link-use-abs-url t
	 :include ("feed.org")
	 :publishing-directory "~/public_html"
	 :publishing-function (org-rss-publish-to-rss)
	 :rss-image-url "https://www.brautaset.org/etc/icon.png"
	 :rss-extension "xml")))

;; Turn off a harmless (but annoying) warning during publication.
;; ("Can't guess python-indent-offset, using defaults 4")
(setq python-indent-guess-indent-offset-verbose nil)
