{
  imports = [
    ./../../modules/hm/darwin
    ./../../modules/hm/zsh
  ];

  home.username = "aorith";
  home.homeDirectory = "/Users/aorith";

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
