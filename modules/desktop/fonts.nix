{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      liberation_ttf
      (nerdfonts.override {fonts = ["FiraCode" "Hack" "JetBrainsMono" "Iosevka"];})
    ];
  };
}
