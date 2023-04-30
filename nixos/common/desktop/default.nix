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
    ./gnome.nix
  ];

  # Fix cursor theme: https://github.com/NixOS/nixpkgs/issues/22652
  environment.systemPackages = [
    defaultCursorPkg
    pkgs.gnome.adwaita-icon-theme
  ];

  services.xserver = {
    xkbOptions = "ctrl:nocaps"; # Capslock as CTRL
    layout = "es";
    xkbVariant = "";
    autoRepeatDelay = 300;
    autoRepeatInterval = 30;
  };
}
