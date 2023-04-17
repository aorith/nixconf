{
  pkgs,
  inputs,
  ...
}: let
  nixPath = "/etc/nixPath";
in {
  nix = {
    extraOptions = ''
      connect-timeout = 5
      min-free = ${toString (1024 * 1024 * 1024 * 10)} # run gc when less than 10G ...
      max-free = ${toString (1024 * 1024 * 1024 * 15)} # ... until at least 15G are free
      log-lines = 35
      fallback = true
      warn-dirty = false
    '';
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["root" "aorith"];
      allowed-users = ["root" "aorith"];
      flake-registry = "${inputs.flake-registry}/flake-registry.json";
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
    "L+ ${nixPath} - - - - ${inputs.nixpkgs-unstable}"
  ];
}
