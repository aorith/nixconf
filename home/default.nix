{self, ...}: let
  hmCfg-unstable = self.inputs.home-manager-unstable.lib.homeManagerConfiguration;

  mkHmCfg = {
    username,
    homeDir,
    stateVer,
    system,
    hmCfg,
    extraModules,
  }: let
    nixpkgsConfig = {
      inherit system;
      config.allowUnfree = true;
    };
    pkgsFrom = {
      main = import self.inputs.nixpkgs nixpkgsConfig;
      unstable = import self.inputs.nixpkgs-unstable nixpkgsConfig;
    };
  in
    hmCfg {
      pkgs = self.inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit pkgsFrom;
        inputs = self.inputs;
      };
      modules =
        [
          {
            programs.home-manager.enable = true;
            home = {
              username = "${username}";
              homeDirectory = "${homeDir}";
              stateVersion = "${stateVer}";
            };
          }
        ]
        ++ extraModules;
    };
in {
  # nix run nixpkgs#home-manager -- switch --flake ".#aorith@trantor"
  "aorith@trantor" = let
    system = "x86_64-linux";
    username = "aorith";
    homeDir = "/home/aorith";
    stateVer = "22.11";
    hmCfg = hmCfg-unstable;
    extraModules = [./linux ./common ./gui];
  in
    mkHmCfg {inherit system username homeDir stateVer hmCfg extraModules;};
  "aorith@moria" = let
    system = "aarch64-darwin";
    username = "aorith";
    homeDir = "/Users/aorith";
    stateVer = "22.11";
    hmCfg = hmCfg-unstable;
    extraModules = [./common];
  in
    mkHmCfg {inherit system username homeDir stateVer hmCfg extraModules;};
}
