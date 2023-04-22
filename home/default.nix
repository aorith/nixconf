{self, ...}: let
  hmCfg-unstable = self.inputs.home-manager-unstable.lib.homeManagerConfiguration;

  mkPkgsFrom = system: let
    nixpkgsConfig = {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    main = import self.inputs.nixpkgs nixpkgsConfig;
    unstable = import self.inputs.nixpkgs-unstable nixpkgsConfig;
  };
in {
  # nix run nixpkgs#home-manager -- switch --flake ".#aorith@trantor"
  "aorith@trantor" = let
    system = "x86_64-linux";
  in
    hmCfg-unstable {
      pkgs = self.inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {pkgsFrom = mkPkgsFrom system;};
      modules = [
        {
          programs.home-manager.enable = true;
          home = {
            username = "aorith";
            homeDirectory = "/home/aorith";
            stateVersion = "22.11";
          };
        }

        ./linux/home.nix
        ./common
        ./gui
      ];
    };
}
