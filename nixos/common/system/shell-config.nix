{
  pkgs,
  pkgsFrom,
  ...
}: let
  exa = pkgs.exa;
in {
  programs = {
    bash = {
      enableLsColors = true;
      enableCompletion = true;
    };
    fish = {
      enable = false;
      useBabelfish = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableBashCompletion = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pkgsFrom.unstable.starship

    bash-completion
  ];

  environment.shellAliases = {
    ll = "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
  };
}
