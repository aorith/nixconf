{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true; # installs extra fonts
    packages = with pkgs; [
      ubuntu_font_family
      iosevka
      cantarell-fonts
      dejavu_fonts
      hack-font
      jetbrains-mono
      liberation_ttf
      libertine
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
