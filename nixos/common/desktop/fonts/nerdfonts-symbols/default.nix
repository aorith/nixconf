{
  pkgs,
  lib,
}: let
  pname = "nerdfonts-symbols";
  version = "2.3.3";
in
  pkgs.stdenv.mkDerivation {
    pname = "${pname}-${version}";
    inherit version;

    src = pkgs.fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/NerdFontsSymbolsOnly.zip";
      hash = "sha256-wKe3692WBlggpAHBLATSq0qdktYk/Rolcjpb/lke1hg=";
      stripRoot = false;
    };

    installPhase = ''
      rm -f *1000*
      rm -f *Windows*
      rm -f *Compatible*
      install -m444 -Dt $out/share/fonts/truetype *.ttf
    '';

    meta = with lib; {
      description = "NerdFonts Symbols Only";
      longDescription = "NerdFonts Symbols Only";
      homepage = "https://github.com/ryanoasis/nerd-fonts";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [];
    };
  }
