{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.system.shell {
    programs = {
      bash = {
        enableLsColors = true;
        enableCompletion = true;
      };
      zsh = {
        enable = true;
        autosuggestions.enable = true;
        enableBashCompletion = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };
    };
  };
}
