{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./packages
    ./programs.nix
    ./fonts
    ./zsh
  ];

  # Add different nixpkgs refs as module args
  _module.args.unstable-pkgs = import inputs.nixpkgs-unstable {
    system = "${pkgs.system}";
    config.allowUnfree = true;
  };

  nix.registry = {
    # Make nix command use the same nixpkgs version: 'nix shell nixpkgs#curl'
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable; # 'nix shell nixpkgs-unstable#curl'
  };

  nix.package = lib.mkDefault pkgs.nix;

  nix.settings = {
    experimental-features = "nix-command flakes";
    min-free = 256000000; # 256 MB
    max-free = 2000000000; # 2 GB
    auto-optimise-store = true;
    nix-path = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixpkgs-unstable=${inputs.nixpkgs.outPath}"
    ];
  };
}
