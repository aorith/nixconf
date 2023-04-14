{pkgs, ...}: let
  nerfonts-symbols = import ./nerdfonts-symbols {
    inherit pkgs;
    lib = pkgs.lib;
  };

  # Icons are misaligned
  #iosevka-fixed = import ./iosevka-fixed {
  #  inherit pkgs;
  #  lib = pkgs.lib;
  #};
  #iosevka-nerd-term = import ./iosevka-nerd {
  #  inherit pkgs;
  #  lib = pkgs.lib;
  #};

  localconf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias>
        <family>monospace</family>
        <prefer><family>Symbols Nerd Font</family></prefer>
      </alias>
      <alias>
        <family>Iosevka Fixed</family>
        <prefer>
          <family>IosevkaTerm Nerd Font</family>
          <family>Symbols Nerd Font</family>
        </prefer>
      </alias>
    </fontconfig>
  '';
in {
  fonts = {
    fontDir.enable = true; # required for flatpak
    enableDefaultFonts = true; # installs extra fonts
    fontconfig = {
      enable = true;
      allowBitmaps = false;
      localConf = localconf;
    };
    fonts = with pkgs; [
      #iosevka-fixed
      #iosevka-nerd-term
      nerfonts-symbols
      dejavu_fonts
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
