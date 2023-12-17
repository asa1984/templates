{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    rust-ovelay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      overlays = [(import inputs.rust-ovelay)];
      pkgs = import inputs.nixpkgs {inherit system overlays;};

      dev-deps = with pkgs; [
        rust-bin.stable.latest.default
      ];
    in {
      devShells.default = pkgs.mkShell {
        packages = dev-deps;
      };
    });
}
