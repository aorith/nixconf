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
      enable = true;
      useBabelfish = true;
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
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
