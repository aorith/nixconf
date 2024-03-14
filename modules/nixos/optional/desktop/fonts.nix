{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false; # installs extra fonts
    packages = with pkgs; [
      liberation_ttf # metric compatible with Arial, Times New Roman and Courier New

      source-code-pro # monospace
      source-sans-pro # sans-serif
      source-serif-pro # serif

      # Wide language coverage
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      fira-code
      fira-code-symbols
      material-design-icons
      noto-fonts-emoji
      ubuntu_font_family

      hack-font
      iosevka
      jetbrains-mono

      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
