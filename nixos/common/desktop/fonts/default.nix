{
  pkgs,
  config,
  ...
}: let
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
    fontDir.enable = false; # required for flatpak
    enableDefaultFonts = true; # installs extra fonts
    fontconfig = {
      enable = true;
      localConf = localconf;
    };
    fonts = with pkgs; [
      #iosevka-fixed
      #iosevka-nerd-term
      nerfonts-symbols

      cantarell-fonts
      dejavu_fonts
      hack-font
      jetbrains-mono
      liberation_ttf
      libertine
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["Hack" "JetBrainsMono" "IBMPlexMono" "DejaVuSansMono"];})
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
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.fonts;
      pathsToLink = ["/share/fonts"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    #"/usr/share/icons" = mkRoSymBind "/run/current-system/sw/share/icons";
    #"/usr/share/pixmaps" = mkRoSymBind "/run/current-system/sw/share/pixmaps";
    #"/usr/share/fonts" = mkRoSymBind "/run/current-system/sw/share/X11/fonts";
    #"/home/aorith/.local/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
    #"/usr/share/sounds" = mkRoSymBind "/run/current-system/sw/share/sounds";
    #"/usr/share/themes" = mkRoSymBind "/run/current-system/sw/share/themes";
    #"/usr/share/backgrounds" = mkRoSymBind "/run/current-system/sw/share/backgrounds";
  };
}
