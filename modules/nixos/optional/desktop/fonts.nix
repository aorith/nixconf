{ unstable-pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false; # installs extra fonts
    packages = with unstable-pkgs; [
      liberation_ttf # metric compatible with Arial, Times New Roman and Courier New

      source-code-pro # monospace
      source-sans-pro # sans-serif
      source-serif-pro # serif

      # Wide language coverage
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji

      material-design-icons
      ubuntu_font_family

      (nerdfonts.override {
        # Font names: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerdfonts/shas.nix
        fonts = [
          "IosevkaTerm"
          "JetBrainsMono"
          "NerdFontsSymbolsOnly"
          "Recursive"
          "SourceCodePro"
        ];
      })
    ];
  };
}
