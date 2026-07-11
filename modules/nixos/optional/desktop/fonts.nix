{ unstable-pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true; # basic set of fonts and reasonable coverage of Unicode
    packages = with unstable-pkgs; [
      liberation_ttf # metric compatible with Arial, Times New Roman and Courier New

      source-code-pro # monospace
      source-sans-pro # sans-serif
      source-serif-pro # serif

      # Wide language coverage
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      material-design-icons
      ubuntu-classic

      nerd-fonts.iosevka-term
      nerd-fonts.hack
    ];
  };
}
