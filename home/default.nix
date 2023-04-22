{self, ...}: let
  hmCfg-unstable = self.inputs.home-manager-unstable.lib.homeManagerConfiguration;
in {
  # nix run nixpkgs#home-manager -- switch --flake ".#aorith@trantor"
  "aorith@trantor" = hmCfg-unstable {
    pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;
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
    ];
  };
}
