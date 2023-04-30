{pkgs, ...}: let
  exa = pkgs.exa;
in {
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  environment.shellAliases = {
    ll = "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
  };
}
