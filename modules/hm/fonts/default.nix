{ unstable-pkgs, ... }:
{
  home.packages = with unstable-pkgs; [
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

    (callPackage ./custom-fonts.nix { })

    # (input-fonts.overrideAttrs
    #   (prev: {
    #     acceptLicense = true;
    #     src = pkgs.fetchzip {
    #       name = "input-fonts-${prev.version}";
    #       url = "https://input.djr.com/build/?fontSelection=whole&a=0&g=0&i=serifs&l=serifs&zero=slash&asterisk=0&braces=0&preset=default&line-height=1&accept=I+do&email=&.zip";
    #       hash = "sha256-cRjtsh4c4bWgkke7vUIqbVF9zqp1V4t/qwShsOCNqGs=";
    #       stripRoot = false;
    #     };
    #   }))

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

  fonts.fontconfig.enable = true;
}
