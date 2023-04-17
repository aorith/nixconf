{pkgs, ...}: {
  services.xserver = {
    enable = true;
    libinput.enable = true;
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
      sessionCommands = ''
        dconf write /org/gnome/desktop/wm/preferences/resize-with-right-button true
        dconf write /org/gnome/desktop/wm/preferences/action-right-click-titlebar 'menu'

        dconf write /org/gnome/desktop/privacy/remove-old-temp-files true
        dconf write /org/gnome/desktop/privacy/remove-old-trash-files true
        dconf write /org/gnome/desktop/privacy/old-files-age 'uint32 30'

        dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
      '';
    };
  };

  services.gnome.gnome-keyring.enable = true;

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
      gnome.gnome-settings-daemon
      gnome.gnome-tweaks
      gnome.seahorse # keyring

      pantheon.elementary-wallpapers

      gnomeExtensions.appindicator
      gnomeExtensions.gsconnect
    ];
  };
}
