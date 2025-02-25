{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    mynur.url = "github:aorith/nur";
    mynur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:aorith/neovim-flake";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      systems,
      treefmt-nix,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      nixosConfigurations = {
        # --- Desktop
        trantor = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/trantor ];
          specialArgs = {
            inherit inputs;
          };
        };
        # --- Hetzner VM
        arcadia = nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/arcadia ];
          specialArgs = {
            inherit inputs;
          };
        };
        # --- NixOS VM (unstable)
        nixos = inputs.nixpkgs-unstable.lib.nixosSystem {
          modules = [ ./hosts/nixos ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      homeConfigurations = {
        # --- Darwin Laptop
        "aorith@moria" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./hosts/moria/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };

      # for `nix fmt`
      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
