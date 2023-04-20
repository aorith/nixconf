{...}: {
  home = {
    username = "aorith";
    homeDirectory = "/home/aorith";
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  home.file.".local/share/flatpak/overrides/global".text = ''
    [Context]
    filesystems=~/.local/share/icons:ro;~/.local/share/fonts:ro;~/.local/share/sounds:ro
  '';
}
