{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    private.url = "/home/aorith/Syncthing/SYNC_STUFF/githome/nixconf/private";
  };

  outputs = inputs: {
    nixosConfigurations = {
      trantor = let
        system = "x86_64-linux";
        overlay-unstable = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      in
        inputs.nixpkgs.lib.nixosSystem
        {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            # allows the use of pkgs.unstable.<pkgname>
            # you can verify it by loading the flake in a repl (nix repl -> :lf .)
            # and checking: outputs.nixosConfigurations.trantor.pkgs.unstable.
            ({pkgs, ...}: {nixpkgs.overlays = [overlay-unstable];})

            ./machines/trantor
            inputs.private.nixosModules.work
            ./modules/virtualisation/media-stack
          ];
        };
    };
  };
}
