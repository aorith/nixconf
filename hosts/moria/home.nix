{
  imports = [
    ./../../modules/hm
    ./../../modules/hm/darwin
  ];

  home.username = "aorith";
  home.homeDirectory = "/Users/aorith";

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
