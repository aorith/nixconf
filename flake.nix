{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    mynur.url = "github:aorith/nur";
    mynur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:aorith/neovim-flake";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    inputs:
    let
      eachSystem = inputs.nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      nixosConfigurations = {
        # --- Desktop
        trantor = inputs.nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/trantor ];
          specialArgs = {
            inherit inputs;
          };
        };
        # --- Hetzner VM
        arcadia = inputs.nixpkgs.lib.nixosSystem {
          modules = [ ./hosts/arcadia ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      homeConfigurations = {
        # --- Darwin Laptop
        "aorith@moria" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./hosts/moria/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };

      formatter = eachSystem (system: inputs.nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
