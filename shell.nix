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
    home-manager
    (nixos { nix.package = nixFlakes; }).nixos-rebuild
  ];

  shellHook = ''
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
