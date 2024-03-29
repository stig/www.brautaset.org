{
  description = "Blog environment";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          myEmacs = ((pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: [
            epkgs.ox-rss
            epkgs.htmlize
            epkgs.clojure-mode
            epkgs.scala-mode
          ]));
        in {
          publish-blog = pkgs.writeShellApplication {
            name = "publish-blog";
            runtimeInputs = [ myEmacs ];
            text = ''
              emacs --batch --quick --load publish.el --eval '(org-publish-all t)'
            '';
          };

          tangle-css = pkgs.writeShellApplication {
            name = "tangle-css";
            runtimeInputs = [ myEmacs ];
            text = ''
              emacs --batch --quick --eval "(require 'ob-tangle)" --eval '(org-babel-tangle-file "style.org")'
            '';
          };

          sync-to-s3 = pkgs.writeShellScriptBin "sync-to-s3" ''
            ${pkgs.awscli2}/bin/aws s3 sync \
              ~/blog/_site 's3://www.brautaset.org/' \
              --delete \
              --acl public-read \
              --cache-control "max-age=86400"
          '';

          cf-invalidation = pkgs.writeShellScriptBin "cf-invalidation" ''
            ${pkgs.awscli2}/bin/aws cloudfront create-invalidation \
              --distribution-id E2HQ2C8QF1FXUZ \
              --paths '/*'
          '';

        });
    };
}
