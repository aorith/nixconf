{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs?ref=nixos-23.11";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "git+file:///home/aorith/githome/neovim-flake";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    sops-nix,
    ...
  } @ inputs: let
    eachSystem = nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  in {
    nixosConfigurations = {
      # --- Desktop
      # -----------
      trantor = let
        system = "x86_64-linux";
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/trantor
            sops-nix.nixosModules.sops
          ];
        };
      # --- Hetzner VM
      # --------------
      arcadia = let
        system = "aarch64-linux";
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/arcadia
            sops-nix.nixosModules.sops
          ];
        };
    };

    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
