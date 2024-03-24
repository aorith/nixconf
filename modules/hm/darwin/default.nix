{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.neovim-flake.packages.${pkgs.system}.nvim-without-config
  ];
}
