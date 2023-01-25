{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    buildInputs = with pkgs; [
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
        epkgs.org
        epkgs.ox-rss
        epkgs.htmlize
        epkgs.clojure-mode
        epkgs.scala-mode
      ]))
    ];

    shellHook = ''
        publish-blog () {
                emacs --batch --quick --load publish.el --eval '(org-publish-all t)'
        }
        tangle-css () {
                emacs --batch --eval "(require 'ob-tangle)" --eval '(org-babel-tangle-file "style.org")'
        }
'';
}
