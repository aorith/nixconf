{self, ...}: let
  hmCfg = self.inputs.home-manager.lib.homeManagerConfiguration;
in {
  # nix run nixpkgs#home-manager -- switch --flake ".#aorith@trantor"
  "aorith@trantor" = hmCfg {
    pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [./trantor/home.nix];
  };
}
