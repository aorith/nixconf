{
  inputs,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  xdg.mime.enable = pkgs.stdenv.isLinux;

  home.packages = with pkgs; [
    bat
    fd
    just

    inputs.neovim-flake.packages.${pkgs.system}.default
  ];

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = false;
      defaultCommand = "fd --type f --follow --exclude .git";
    };
  };
}
