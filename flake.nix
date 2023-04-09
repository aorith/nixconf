{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    neovim-flake = {
      url = "github:aorith/neovim-flake";
    };
    private.url = "/home/aorith/Syncthing/SYNC_STUFF/githome/nixconf/private";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs: let
    # Helper to create nixosConfigurations
    mkNixosCfg = hostname: system: let
      overlay-unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          # allows the use of pkgs.unstable.<pkgname>
          # you can verify it by loading the flake in a repl (nix repl -> :lf .)
          # and checking: outputs.nixosConfigurations.trantor.pkgs.unstable.
          ({pkgs, ...}: {nixpkgs.overlays = [overlay-unstable inputs.neovim-flake.overlays.default];})

          ./machines/${hostname}
        ];
      };
  in
    {
      nixosConfigurations = {
        trantor = mkNixosCfg "trantor" "x86_64-linux";
        msi = mkNixosCfg "msi" "x86_64-linux";
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
    in {
      formatter = pkgs.alejandra;
    });
}
