{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-flake.url = "github:aorith/neovim-flake";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:Mic92/sops-nix";

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

  outputs = inputs:
    {
      nixosConfigurations = import ./nixos inputs;
      homeConfigurations = import ./home inputs;
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs-unstable = inputs.nixpkgs.legacyPackages.${system};
    in {
      formatter = pkgs-unstable.alejandra;
    });
}
