{pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    layout = "es";
    xkbVariant = "";
  };

  xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect
    gnomeExtensions.appindicator
  ];
}
