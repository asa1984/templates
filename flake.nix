{
  outputs = inputs: {
    templates = {
      flake = {
        path = ./flake;
        description = "Basic flake templates";
      };
      rust = {
        path = ./rust/default;
        description = "Rust dev environment templates";
      };
      rust-wasm = {
        path = ./rust/wasm;
        description = "Rust with WASM dev environment templates";
      };
      nodejs = {
        path = ./nodejs;
        description = "Node.js dev environment templates";
      };
      unfree = {
        path = ./unfree;
      };
    };
  };
}
