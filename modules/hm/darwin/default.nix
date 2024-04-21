{
  inputs,
  pkgs,
  unstable-pkgs,
  ...
}: {
  home.packages = [
    inputs.neovim-flake.packages.${pkgs.system}.nvim-without-config
    unstable-pkgs.terraform # homebrew will remove it because of the license
  ];
}
