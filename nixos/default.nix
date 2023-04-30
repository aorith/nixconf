{self, ...}: let
  # Helper to create nixosConfigurations
  mkNixosCfg = hostname: system: nixpkgs: let
    nixpkgsConfig = {
      inherit system;
      config.allowUnfree = true;
    };
    pkgsFrom = {
      stable = import self.inputs.nixpkgs-stable nixpkgsConfig;
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inputs = self.inputs;
        inherit pkgsFrom;
      };

      modules = [
        {
          networking = {
            hostName = hostname;
            hostId = builtins.substring 24 8 (builtins.hashString "md5" "${hostname}");
          };
          nixpkgs.hostPlatform = system;
        }

        self.inputs.agenix.nixosModules.default
        self.inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        ../modules
        ./hosts/${hostname}
      ];
    };
in {
  trantor = mkNixosCfg "trantor" "x86_64-linux" self.inputs.nixpkgs;
  msi = mkNixosCfg "msi" "x86_64-linux" self.inputs.nixpkgs;
}
