# Activate with nix-shell
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "InitialShell";
  nativeBuildInputs = with pkgs; [
    age
    sops
    git
    nixUnstable
    (nixos {nix.package = nixFlakes;}).nixos-rebuild
  ];

  shellHook = ''
    PATH=${
      pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
      ''
    }/bin:$PATH
  '';
}
