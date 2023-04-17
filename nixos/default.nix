{self, ...}: let
  # Helper to create nixosConfigurations
  mkNixosCfg = hostname: system: nixpkgs: let
    overlay-unstable = final: prev: {
      unstable = import self.inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inputs = self.inputs;};
      modules = [
        # allows the use of pkgs.unstable.<pkgname>
        # you can verify it by loading the flake in a repl (nix repl -> :lf .)
        # and checking: outputs.nixosConfigurations.trantor.pkgs.unstable.
        ({pkgs, ...}: {nixpkgs.overlays = [overlay-unstable];})

        {
          networking = {
            hostName = hostname;
            hostId = builtins.substring 24 8 (builtins.hashString "md5" "${hostname}");
          };
          nixpkgs.hostPlatform = "x86_64-linux";
        }

        self.inputs.sops-nix.nixosModules.sops
        ../modules
        ./hosts/${hostname}
      ];
    };
in {
  trantor = mkNixosCfg "trantor" "x86_64-linux" self.inputs.nixpkgs;
  msi = mkNixosCfg "msi" "x86_64-linux" self.inputs.nixpkgs-unstable;
}
