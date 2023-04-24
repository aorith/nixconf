{
  inputs,
  pkgs,
  pkgsFrom,
  ...
}: {
  home.packages = [
    pkgsFrom.unstable.just
  ];

  fonts.fontconfig.enable = true;
  xdg.mime.enable = pkgs.stdenv.isLinux;

  programs.neovim = {
    enable = pkgs.stdenv.isDarwin;
    package = inputs.neovim-flake.packages.${pkgs.system}.default;
  };
}
