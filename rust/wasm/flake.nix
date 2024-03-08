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

      devDeps = with pkgs; [
        (rust-bin.stable.latest.default.override {
          targets = ["wasm32-unknown-unknown" "wasm32-wasi"];
        })
        wasmtime
      ];
    in {
      devShells.default = pkgs.mkShell {
        packages = devDeps;
      };
    });
}
