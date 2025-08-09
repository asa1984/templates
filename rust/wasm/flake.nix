{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-ovelay.url = "github:oxalica/rust-overlay";

    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:

        let
          devDeps = with pkgs; [
            (rust-bin.stable.latest.default.override {
              targets = [
                "wasm32-unknown-unknown"
                "wasm32-wasi"
              ];
            })
            wasmtime
          ];
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.rust-ovelay.overlays.default
            ];
          };

          devShells = {
            default = pkgs.mkShell {
              packages = devDeps;
            };
          };
        };
    };
}
