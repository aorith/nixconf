{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-flake.url = "github:aorith/neovim-flake";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
  };

  outputs = inputs: let
    forAllSystems = inputs.nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  in {
    nixosConfigurations = import ./nixos inputs;
    formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
  };
}
