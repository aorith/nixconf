{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../../modules/hm
    ./../../modules/hm/darwin
  ];

  # Add different nixpkgs refs as module args
  _module.args.unstable-pkgs = import inputs.nixpkgs-unstable {
    system = "${pkgs.system}";
    config.allowUnfree = true;
  };

  home.username = "aorith";
  home.homeDirectory = "/Users/aorith";

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
