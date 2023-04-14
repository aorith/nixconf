{
  pkgs,
  lib,
}: let
  pname = "iosevka-fixed";
  version = "22.0.0";
in
  pkgs.stdenv.mkDerivation {
    pname = "${pname}-${version}";
    inherit version;

    src = pkgs.fetchzip {
      # https://github.com/be5invis/Iosevka/blob/v22.0.0/doc/PACKAGE-LIST.md
      url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/super-ttc-sgr-iosevka-fixed-${version}.zip";
      hash = "sha256-d/5ofP6QTCjeZ4X2T81plwd/uMjzKou4HmwlxHAwF7c=";
    };

    installPhase = ''
      install -m444 -Dt $out/share/fonts/ttc *.ttc
    '';

    meta = with lib; {
      description = "Iosevka Fixed";
      longDescription = "Iosevka Fixed — Monospace, Default";
      homepage = "https://github.com/be5invis/Iosevka";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = [];
    };
  }
