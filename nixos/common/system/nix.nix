{
  pkgs,
  inputs,
  ...
}: let
  nixPath = "/etc/nixPath";

  kibibyte = 1024;
  mibibyte = 1024 * kibibyte;
  gibibyte = 1024 * mibibyte;
in {
  nix = {
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      flake-registry = "${inputs.flake-registry}/flake-registry.json";
      warn-dirty = false;
      fallback = true;
      log-lines = 50;
      connect-timeout = 7;
      min-free = 5 * gibibyte; # run gc when less than 5GiB ...
      max-free = 20 * gibibyte; # ... until at least 25GiB are free

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 25d";
    };

    # Nix path for non-flake commands
    nixPath = ["nixpkgs=${nixPath}"];
  };

  systemd.tmpfiles.rules = [
    "L+ ${nixPath} - - - - ${inputs.nixpkgs}"
  ];
}
