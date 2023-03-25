{pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    layout = "es";
    xkbVariant = "";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome.geary
      gnome.gnome-music
      gnome.totem
    ];
    systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator
    ];
  };
}
