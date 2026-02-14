# Activate with nix-shell
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  name = "InitialShell";
  nativeBuildInputs = with pkgs; [
    age
    git
    sops
    gnumake
  ];

  shellHook = ''
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nix}/bin/nix --option experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
