{
  description = "Blog environment";

  inputs.ox-rss.url = "github:stig/nixpkgs/ox-rss";

  outputs = { self, ox-rss }:
    let
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
      forAllSystems = ox-rss.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import ox-rss { inherit system; });
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in {
          publish-blog = pkgs.writeShellApplication {
            name = "publish-blog";
            runtimeInputs = [
              ((pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: [
                epkgs.ox-rss
                epkgs.htmlize
                epkgs.clojure-mode
                epkgs.scala-mode
              ]))
            ];

            text = ''
              emacs --batch --quick --load publish.el --eval '(org-publish-all t)'
            '';
          };

          tangle-css = pkgs.writeShellScriptBin "tangle-css" ''
            ${pkgs.emacs}/bin/emacs --batch --quick --eval "(require 'ob-tangle)" --eval '(org-babel-tangle-file "style.org")'
          '';

        });
    };
}
