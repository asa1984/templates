{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
      devDeps = with pkgs; [
        ocaml
        dune_3
        ocamlformat
        ocamlPackages.ocaml-lsp
        ocamlPackages.utop
      ];
    in {
      devShell = pkgs.mkShell {
        packages = devDeps;
      };
    });
}
