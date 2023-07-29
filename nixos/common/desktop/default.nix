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
    ./fonts
    ./timers.nix
    ./gnome.nix
    #./i3wm
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.mpv
    pkgs.ungoogled-chromium
    pkgs.wezterm

    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.xsel

    # Fix cursor theme: https://github.com/NixOS/nixpkgs/issues/22652
    defaultCursorPkg
    pkgs.gnome.adwaita-icon-theme
  ];

  services.xserver = {
    enable = true;
    libinput.enable = true;
    xkbOptions = "ctrl:nocaps"; # Capslock as CTRL
    layout = "es";
    xkbVariant = "";
    autoRepeatDelay = 300;
    autoRepeatInterval = 30;
    displayManager.importedVariables = [
      # include extra variables to systemd env: systemctl --user show-environment
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_DESKTOP"
    ];
  };
}
