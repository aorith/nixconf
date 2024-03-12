{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false; # installs extra fonts
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      hack-font
      iosevka
      jetbrains-mono
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
