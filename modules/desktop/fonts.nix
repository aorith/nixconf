{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true; # installs extra fonts
    packages = with pkgs; [
      cantarell-fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      hack-font
      iosevka
      jetbrains-mono
      liberation_ttf
      libertine
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      ubuntu_font_family

      material-design-icons
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
