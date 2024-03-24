{
  imports = [../../modules/hm/zsh];

  home.username = "aorith";
  home.homeDirectory = "/home/aorith";

  home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
