{
  inputs,
  pkgs,
  pkgsFrom,
  ...
}: {
  home.packages = [
    pkgsFrom.unstable.just
  ];

  xdg.mime.enable = pkgs.stdenv.isLinux;

  programs.neovim = {
    enable = true;
    package = inputs.neovim-flake.packages.${pkgs.system}.default;
  };
}
