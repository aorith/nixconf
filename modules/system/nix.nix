{
  pkgs,
  inputs,
  ...
}: {
  nix = {
    extraOptions = ''
      min-free = ${toString (1024 * 1024 * 1024 * 10)} # run gc when less than 10G ...
      max-free = ${toString (1024 * 1024 * 1024 * 15)} # ... until at least 15G are free
    '';
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["root" "aorith"];
      allowed-users = ["root" "aorith"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
  };
}
