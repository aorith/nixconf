{
  lib,
  pkgs,
  pkgsFrom,
  ...
}: {
  xdg.portal = {
    wlr.enable = lib.mkForce false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment = {
    pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
    systemPackages = [
      pkgsFrom.unstable.dmenu
      pkgsFrom.unstable.picom
      pkgsFrom.unstable.rofi
      pkgsFrom.unstable.unclutter
      pkgsFrom.unstable.dunst
      pkgsFrom.unstable.dex # autostart XDG .desktop files
      pkgsFrom.unstable.xss-lock
      pkgsFrom.unstable.networkmanagerapplet
    ];
  };

  services.xserver = {
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      lightdm = {
        enable = true;
      };
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      package = pkgsFrom.unstable.i3;
      extraPackages = [
        pkgsFrom.unstable.i3lock
        pkgsFrom.unstable.i3status
      ];
    };
  };
}
