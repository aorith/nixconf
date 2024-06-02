{ pkgs, ... }:
{
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
      sessionCommands = ''
        set -x
        dconf write /org/gnome/desktop/wm/preferences/resize-with-right-button true
        dconf write /org/gnome/desktop/wm/preferences/action-right-click-titlebar "'menu'"

        dconf write /org/gnome/desktop/privacy/remember-recent-files false
        dconf write /org/gnome/desktop/privacy/remove-old-temp-files true
        dconf write /org/gnome/desktop/privacy/remove-old-trash-files true
        dconf write /org/gnome/desktop/privacy/old-files-age 'uint32 30'

        dconf write /org/gnome/desktop/session/idle-delay 'uint32 0'
        dconf write /org/gnome/desktop/search-providers/disabled "['org.gnome.Contacts.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop', 'org.gnome.seahorse.Application.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Epiphany.desktop']"

        dconf write /org/gnome/mutter/dynamic-workspaces true
        dconf write /org/gnome/mutter/edge-tiling true
        dconf write /org/gnome/mutter/workspaces-only-on-primary true

        dconf write /org/gnome/desktop/interface/clock-show-weekday true

        dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
      '';
    };
  };

  services.gnome.gnome-keyring.enable = true;

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

      gnomeExtensions.appindicator
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.gsconnect
      gnomeExtensions.solaar-extension
    ];
  };
}
