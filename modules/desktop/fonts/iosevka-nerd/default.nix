{
  pkgs,
  lib,
}: let
  pname = "iosevka-nerd";
  version = "2.3.3";
in
  pkgs.stdenv.mkDerivation {
    pname = "${pname}-${version}";
    inherit version;

    src = pkgs.fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Iosevka.zip";
      #sha256 = "1111111111111111111111111111111111111111111111111111111111111111";
      hash = "sha256-7kSc25iNc41TbfwyBPgEGI2cCGn0Wt33fy287ui3g3g=";
      stripRoot = false;
    };

    installPhase = ''
      rm -f *"Iosevka Nerd Font"*
      rm -f *"Complete Mono"*
      rm -f *Windows*
      rm -f *Compatible*
      install -m444 -Dt $out/share/fonts/truetype *.ttf
    '';

    meta = with lib; {
      description = "Iosevka Fixed";
      longDescription = "Iosevka Term Nerd Font";
      homepage = "https://github.com/ryanoasis/nerd-fonts";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = [];
    };
  }
