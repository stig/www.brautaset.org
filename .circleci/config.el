(defun sb/org-html-format-drawer (name content)
  (concat "<div class=\"drawer " (downcase name) "\">\n"
	  "<h6>" (capitalize name) "</h6>\n"
	  content
	  "\n</div>"))

(setq org-publish-project-alist
      '(("www"
	 :components ("www-pages" "www-static" "www-rss"))

	("www-static"
	 :base-directory "~/blog"
	 :publishing-directory "~/public_html"
	 :base-extension "css\\|jpg\\|png\\|pdf\\|html"
	 :recursive t
	 :publishing-function org-publish-attachment)

	("www-pages"
	 :exclude ",.*"
	 :base-directory "~/blog"
	 :publishing-directory "~/public_html"
	 :publishing-function org-html-publish-to-html
	 :recursive t
	 :section-numbers nil
	 :time-stamp-file nil
	 :with-toc nil
	 :with-drawers t
	 :html-format-drawer-function sb/org-html-format-drawer

	 :html-html5-fancy t
	 :html-doctype "html5"
	 :html-footnotes-section "<div id=\"footnotes\"><!--%s-->%s</div>"
	 :html-link-up "/"
	 :html-link-home "/"
	 :html-home/up-format "
       <div id=\"org-div-home-and-up\">
	 <nav>
	   <ul>
	     <li><a accesskey=\"H\" href=\"%s\"> Home </a> (<a href=\"/index.xml\">RSS</a>)</li>
	     <li><a accesskey=\"p\" href=\"/publications.html\"> Publications </a></li>
	     <li><a accesskey=\"A\" href=\"/about.html\"> About </a></li>
	     <li>Licence: <a accesskey=\"l\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">CC BY-SA 4.0</a></li>
	   </ul>
	 </nav>
       </div>"
	 :html-head "
       <link rel=\"stylesheet\" type=\"text/css\" href=\"/etc/main.css\" />
       <link rel=\"icon\" type=\"image/png\" href=\"/etc/icon.png\" />
       <link rel=\"alternative\" type=\"application/rss+xml\"
	     href=\"https://www.brautaset.org/index.xml\"
	     title=\"Stig's Soapbox RSS Feed\" />
       <meta name=\"referrer\" content=\"same-origin\">
     "

	 :html-head-include-default-style nil
	 :html-head-include-scripts nil

	 :html-preamble nil
	 :html-postamble-format auto
	 :html-metadata-timestamp-format "%e %B %Y")

	("www-rss"
	 :base-directory "~/blog"
	 :base-extension "org"
	 :html-link-home "https://www.brautaset.org"
	 :html-link-use-abs-url t
	 :rss-extension "xml"
	 :publishing-directory "~/public_html"
	 :publishing-function (org-rss-publish-to-rss)
	 :section-numbers nil
	 :exclude ".*"              ;; To exclude all files...
	 :include ("index.org")     ;; ... except index.org.
	 :table-of-contents nil)))

