{
  pkgs,
  lib,
  ...
}: let
  indexThemeText = theme: lib.generators.toINI {} {"icon theme" = {Inherits = "${theme}";};};

  mkDefaultCursorFile = theme:
    pkgs.writeTextDir
    "share/icons/default/index.theme"
    "${indexThemeText theme}";

  defaultCursorPkg = mkDefaultCursorFile "Adwaita";
in {
  imports = [
    ./sound.nix
    ./fonts.nix
    ./packages.nix
    ./gui-packages.nix
    ./gnome.nix
    #./kde.nix
  ];

  environment.systemPackages = [
    # Fix cursor theme: https://github.com/NixOS/nixpkgs/issues/22652
    defaultCursorPkg
    pkgs.gnome.adwaita-icon-theme
  ];

  services.xserver = {
    enable = lib.mkDefault true;
    libinput.enable = true;
    xkb.options = "ctrl:nocaps"; # Capslock as CTRL
    xkb.layout = "es";
    autoRepeatDelay = 300;
    autoRepeatInterval = 30;
    displayManager.importedVariables = [
      # include extra variables to systemd env: systemctl --user show-environment
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_DESKTOP"
    ];
  };

  # Common services
  services = {
    fwupd.enable = true;
    gvfs.enable = true;
  };

  # Allow users/groups to request real-time priority
  security.pam.loginLimits = [
    {
      domain = "aorith"; # or @users
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
}
