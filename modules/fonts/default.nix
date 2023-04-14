{
  lib,
  config,
  ...
}: let
  cfg = config.aorith.fonts.lowdpi;
in {
  options.aorith.fonts.lowdpi = {
    enable = lib.mkEnableOption "low dpi font settings";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "hintmedium";
      };
      subpixel.lcdfilter = "default";
    };
  };
}
