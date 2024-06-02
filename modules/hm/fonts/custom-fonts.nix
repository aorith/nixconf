{ stdenv, fetchurl }:
stdenv.mkDerivation (finalAttrs: {
  pname = "custom-fonts";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/aorith/custom-fonts/archive/refs/tags/v${finalAttrs.version}.tar.gz";
    hash = "sha256-XYcgqKEEQ2MsCzl1eciO1DiGo3SA/KdiR7q3dydp0Q4=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    while read -r tarball; do
      tmpdir="$(mktemp -d)"
      tar -xf "$tarball" -C "$tmpdir/"
      install -Dm 444 "$tmpdir"/share/fonts/truetype/*.ttf "$out/share/fonts/truetype/"
    done < <(find "out/" -type f -name '*.tar.xz' -print)

    # Ensure fonts are installed
    (($(find "$out/" -type f -name "*.ttf" -print | wc -l) > 0)) || { echo "NO FONTS FOUND."; exit 1; }

    runHook postInstall
  '';
})
