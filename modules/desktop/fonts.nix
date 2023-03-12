{pkgs, ...}: {
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["FiraCode" "Hack" "JetBrainsMono" "Iosevka"];})
  ];
}
