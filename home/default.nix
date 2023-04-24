{self, ...}: let
  hmCfg-unstable = self.inputs.home-manager-unstable.lib.homeManagerConfiguration;

  mkHmCfg = {
    username,
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
              homeDirectory =
                if (builtins.match ".*(darwin)" "${system}" != null)
                then "/Users/${username}"
                else "/home/${username}";
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
    stateVer = "22.11";
    hmCfg = hmCfg-unstable;
    extraModules = [
      ./modules/linux
      ./modules/common/home.nix
      ./modules/common/shell-config.nix
      ./modules/common/gui.nix
    ];
  in
    mkHmCfg {inherit system username stateVer hmCfg extraModules;};
  "aorith@moria" = let
    system = "aarch64-darwin";
    username = "aorith";
    stateVer = "22.11";
    hmCfg = hmCfg-unstable;
    extraModules = [
      ./modules/common/home.nix
      ./modules/common/shell-config.nix
    ];
  in
    mkHmCfg {inherit system username stateVer hmCfg extraModules;};
}
