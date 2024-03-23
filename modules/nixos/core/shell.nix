{
  programs = {
    bash = {
      enableLsColors = true;
      enableCompletion = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
    };
  };

  # Completion for system packages
  environment.pathsToLink = ["/share/zsh"];
}
