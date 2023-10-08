{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };

        noto-serif-jp = pkgs.fetchzip {
          url = "https://github.com/notofonts/noto-cjk/releases/download/Serif2.002/07_NotoSerifCJKjp.zip";
          stripRoot = false;
          hash = "sha256-GbE1VKJ+eLprWfkI3GOmaOUavnmNocF7+L2H36BKN3E=";
        };
        noto-sans-jp = pkgs.fetchzip {
          url = "https://github.com/notofonts/noto-cjk/releases/download/Sans2.004/06_NotoSansCJKjp.zip";
          stripRoot = false;
          hash = "sha256-QoAXVSotR8fOLtGe87O2XHuz8nNQrTBlydo5QY/LMRo=";
        };

        fonts = pkgs.stdenv.mkDerivation {
          name = "typst-fonts";
          phases = ["installPhase"];

          # Extract *.otf files from downloaded files
          installPhase = ''
            mkdir -p $out
            mkdir fonts
            cp -r ${noto-serif-jp} fonts
            cp -r ${noto-sans-jp} fonts
            find fonts -type f -name "*.otf" -exec mv {} $out \;
          '';
        };

        deps = with pkgs; [
          typst
          typst-fmt
          typst-lsp

          fzf # Fuzzy finder
          evince # PDF viewer
        ];

        scripts = with pkgs; [
          # Compile typst files
          (writeScriptBin "compile" ''
            if [ -z "$1" ]; then
              typst compile $(fzf) --font-path ${fonts}
              exit 1
            fi
            typst compile "$@" --font-path ${fonts}
          '')

          # Hotreload typst files
          (writeScriptBin "watch" ''
            if [ -z "$1" ]; then
              typst watch $(fzf) --font-path ${fonts}
              exit 1
            fi
            typst watch "$@" --font-path ${fonts} &
          '')
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = deps ++ scripts;
        };
      }
    );
}
