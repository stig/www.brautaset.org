#!/usr/bin/env emacs --script

(require 'package)
(package-initialize)
(load-file (expand-file-name "~/.emacs.d/Org.el"))

(setq project-path (file-name-directory
                    (or (buffer-file-name)
                        load-file-name))

      ;; For now deploy side-by-side, since I cannot figure out how to
      ;; simulate a Jekyll site so it will deploy from _site :-(
      publish-path project-path ;; (concat project-path "_site/")

      org-html-home/up-format "
<div id=\"org-div-home-and-up\">
  <img src=\"/images/logo.png\"/>
  <nav>
    <ul>
      <!-- <li><a accesskey=\"h\" href=\"%s\"> Up </a></li>\n -->
      <li><a accesskey=\"H\" href=\"%s\"> Home </a></li>
      <li><a accesskey=\"a\" href=\"/articles\"> Articles </a></li>
      <li><a accesskey=\"p\" href=\"/publications.html\"> Publications </a></li>
      <li><a accesskey=\"A\" href=\"/about.html\"> About </a></li>
    </ul>
  </nav>
</div>
"

      org-html-head (concat "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/main.css\" />\n"
                            "<link rel=\"icon\" type=\"image/png\" href=\"/images/icon.png\" />")

      org-html-scripts (concat org-html-scripts
                               "
<script type=\"text/javascript\">
if(/superloopy\.io/.test(window.location.hostname)) {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-4113456-6', 'auto');
  ga('send', 'pageview');
}
</script>")

      org-html-link-home "/"
      org-html-link-up "/"

      org-export-with-toc nil
      org-export-with-author t
      org-export-with-email nil
      org-export-with-creator nil
      org-export-with-section-numbers nil

      org-html-preamble nil
      org-html-postamble 'auto

      org-publish-project-alist
      `(("static"
         :base-directory ,project-path
         :base-extension "css\\|png\\|jpg\\|pdf"
         :exclude "_site"
         :publishing-directory ,publish-path
         :publishing-function org-publish-attachment
         :recursive t)

        ("home"
         :base-directory ,project-path
         :publishing-directory ,publish-path
         :publishing-function org-html-publish-to-html)

        ("articles"
         :base-directory ,(concat project-path "articles")
         :makeindex t
         :publishing-directory ,(concat publish-path "articles")
         :publishing-function org-html-publish-to-html
         :recursive t)))

(require 'ox)
(org-publish-all t)
