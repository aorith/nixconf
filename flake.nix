{
  description = "One Nix flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs: {
    nixosConfigurations = {
      trantor = let
        system = "x86_64-linux";
        overlay-unstable = final: prev: {
          unstable = import inputs.unstable {
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
            machines/trantor
          ];
        };
    };
  };
}
