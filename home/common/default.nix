{
  inputs,
  pkgs,
  pkgsFrom,
  ...
}: {
  imports = [./shell-config.nix];

  home.packages = [
    pkgsFrom.unstable.just
    pkgs.hack-font
  ];

  fonts = {
    fontconfig.enable = true;
  };
  xdg.mime.enable = pkgs.stdenv.isLinux;

  programs.neovim = {
    enable = pkgs.stdenv.isDarwin;
    package = inputs.neovim-flake.packages.${pkgs.system}.default;
  };
}
