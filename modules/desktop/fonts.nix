{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true; # required for flatpak
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Hack"];
        sansSerif = ["Noto Sans"];
        serif = ["Noto Serif"];
      };
    };
    fonts = with pkgs; [
      corefonts
      hack-font
      liberation_ttf
      libertine
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["Hack" "JetBrainsMono"];})
    ];
  };

  # Workaround for flatpak icons and fonts
  environment.systemPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind "/run/current-system/sw/share/icons";
    "/usr/share/fonts" = mkRoSymBind "/run/current-system/sw/share/X11/fonts";
    "/usr/share/sounds" = mkRoSymBind "/run/current-system/sw/share/sounds";
  };
}
