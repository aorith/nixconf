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
