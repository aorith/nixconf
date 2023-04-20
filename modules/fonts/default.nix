{
  lib,
  config,
  ...
}: let
  cfg = config.custom.fonts.lowdpi;
in {
  options.custom.fonts.lowdpi = {
    enable = lib.mkEnableOption "low dpi font settings";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "hintslight";
      };
      subpixel.lcdfilter = "default";
    };
  };
}
