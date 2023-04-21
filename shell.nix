# Activate with nix-shell
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "InitialShell";
  nativeBuildInputs = with pkgs; [
    age
    git
    nixUnstable
    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {})
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
