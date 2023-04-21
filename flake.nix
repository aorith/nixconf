{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-flake.url = "github:aorith/neovim-flake";
    agenix.url = "github:ryantm/agenix";
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    homeConfigurations = import ./home inputs;
    formatter = forAllSystems (system: inputs.nixpkgs-unstable.legacyPackages.${system}.alejandra);
  };
}
