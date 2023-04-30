{
  inputs,
  pkgs,
  pkgsFrom,
  ...
}: {
  home.packages = [
    pkgsFrom.unstable.just
    pkgs.bat
    inputs.neovim-flake.packages.${pkgs.system}.default
  ];

  fonts.fontconfig.enable = true;
  xdg.mime.enable = pkgs.stdenv.isLinux;
}
