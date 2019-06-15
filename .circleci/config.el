;; Don't use inline CSS for source code
(setq org-html-htmlize-output-type "css")

(setq org-html-footnotes-section
      "<div id=\"footnotes\"><!--%s-->%s</div>")

(setq org-export-time-stamp-file nil)
(setq org-export-with-drawers t)
(setq org-export-with-section-numbers nil)
(setq org-export-with-toc nil)

(setq org-html-doctype "html5")
(setq org-html-head-include-default-style nil)
(setq org-html-head-include-scripts nil)
(setq org-html-html5-fancy t)
(setq org-html-metadata-timestamp-format "%e %B %Y")

(setq org-html-format-drawer-function
      (lambda (name content)
	(format "<div class=\"drawer %s\"><h6>%s</h6>%s</div>"
		(downcase name)
		(capitalize name)
		content)))

(defun sb/html-head (prefix)
  (format "
       <link rel=\"stylesheet\" type=\"text/css\" href=\"%setc/main.css\" />
       <link rel=\"icon\" type=\"image/png\" href=\"%setc/icon.png\" />
       <link rel=\"alternative\" type=\"application/rss+xml\"
	     href=\"https://www.brautaset.org/index.xml\"
	     title=\"Stig's Soapbox RSS Feed\" />
       <meta name=\"referrer\" content=\"same-origin\">
" prefix prefix))

(setq sb/copyright
      "<p>Copyright &copy; 2011-2019 Stig Brautaset</p>")

(defun sb/preamble (prefix)
  (format "
	 <nav>
	   <ul>
	     <li><a accesskey=\"H\" href=\"%sindex.html\"> Home </a></li>
	     <li><a accesskey=\"p\" href=\"%spublications.html\"> Publications </a></li>
	     <li><a accesskey=\"A\" href=\"%sabout.html\"> About </a></li>
	   </ul>
	 </nav>
       " prefix prefix prefix))

(defun sb/postamble (prefix)
  (concat
   (sb/preamble prefix)
   sb/copyright))

(setq common-properties
      '(
	:author "Stig Brautaset"
	:email "stig@brautaset.org"
	:base-directory "~/blog"
	:publishing-directory "~/public_html"
	))

(setq org-publish-project-alist
      `(("www"
	 :components ("www-pages" "www-articles" "www-static" "www-rss"))

	("www-static"
	 ,@common-properties
	 :base-extension "css\\|jpg\\|png\\|pdf\\|html"
	 :recursive t
	 :publishing-function org-publish-attachment)

	("www-pages"
	 ,@common-properties
	 :publishing-function org-html-publish-to-html
	 :html-preamble ,(sb/preamble "")
	 :html-postamble ,(sb/postamble "")
	 :html-head ,(sb/html-head ""))

	("www-articles"
	 ,@common-properties
	 :base-directory "~/blog/articles"
	 :publishing-directory "~/public_html/articles"
	 :publishing-function org-html-publish-to-html
	 :recursive t
	 :html-postamble ,(sb/postamble "../../")
	 :html-head ,(sb/html-head "../../"))

	("www-rss"
	 ,@common-properties
	 :base-extension "org"
	 :html-link-home "https://www.brautaset.org"
	 :html-link-use-abs-url t
	 :rss-extension "xml"
	 :publishing-function (org-rss-publish-to-rss)
	 :exclude ".*"              ;; To exclude all files...
	 :include ("index.org"))))  ;; ... except index.org.
