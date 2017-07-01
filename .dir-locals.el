((org-mode . ((org-export-time-stamp-file . nil)
              (org-export-with-toc . nil)
              (org-export-with-section-numbers . nil)

              (org-html-doctype . "html5")
              (org-html-footnotes-section . "<div id=\"footnotes\"><!--%s-->%s</div>")

              (org-html-link-up . "/")
              (org-html-link-home . "/")
              (org-html-home/up-format . "
<div id=\"org-div-home-and-up\">
  <img src=\"/images/logo.png\" alt=\"Superloopy Logo\"/>
  <nav>
    <ul>
      <li><a accesskey=\"H\" href=\"%s\"> Home </a></li>
      <li><a accesskey=\"p\" href=\"/publications.html\"> Publications </a></li>
      <li><a accesskey=\"A\" href=\"/about.html\"> About </a></li>
      <li><a accesskey=\"c\" href=\"/contact.html\"> Contact </a></li>
    </ul>
  </nav>
</div>
")
              (org-html-head-include-default-style . nil)
              (org-html-head . "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/main.css\" />
<link rel=\"icon\" type=\"image/png\" href=\"/images/icon.png\" />")
              (org-html-head-extra . "<script type=\"text/javascript\">
if(/superloopy\.io/.test(window.location.hostname)) {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-4113456-6', 'auto');
  ga('send', 'pageview');
}
</script>")

              (org-html-preamble . nil)
              (org-html-postamble . t)
              (org-html-postamble-format . (("en" "<p class=\"author\">Author: <a href=\"/contact.html\">%a</a></p>
<p class=\"licence\">Licence: <a href=\"https://creativecommons.org/licenses/by-sa/4.0/\">CC BY-SA 4.0</a></p>
<p class=\"validation\">%v</p>")))

              (eval . (setq-default org-publish-project-alist
                                    `(("home"
                                       :recursive t
                                       :makeindex t
                                       :base-directory ,(expand-file-name "~/blog")
                                       :publishing-directory ,(expand-file-name "~/blog")
                                       :publishing-function org-html-publish-to-html)))))))
