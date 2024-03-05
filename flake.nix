{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs?ref=nixos-23.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager?ref=release-23.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "git+file:///home/aorith/githome/neovim-flake";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    sops-nix,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  in {
    nixosConfigurations = {
      # --- Desktop
      # -----------
      trantor = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/trantor
          ({inputs, ...}: {environment.systemPackages = [inputs.neovim-flake.packages.${system}.default];})
          inputs.sops-nix.nixosModules.sops
        ];
      };
      # --- Hetzner VM
      # --------------
      arcadia = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/arcadia
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
