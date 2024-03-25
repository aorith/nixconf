{inputs, ...}: {
  nixpkgs.config.allowUnfree = true;

  nix.registry = {
    # Make nix command use the same nixpkgs version: 'nix shell nixpkgs#curl'
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable; # 'nix shell nixpkgs-unstable#curl'
  };

  # Also the non-flake commands like 'nix-shell'
  nix.nixPath = ["nixpkgs=/etc/nixpkgs" "nixpkgs-unstable=/etc/nixpkgs-unstable"];
  environment.etc."nixpkgs".source = inputs.nixpkgs.outPath;
  environment.etc."nixpkgs-unstable".source = inputs.nixpkgs-unstable.outPath;

  nix.settings = {
    experimental-features = "nix-command flakes";

    max-jobs = "auto";

    # The timeout (in seconds) for establishing connections in the binary cache substituter.
    # It corresponds to curl’s –connect-timeout option. A value of 0 means no limit.
    connect-timeout = 5;

    # The number of lines of the tail of the log to show if a build fails.
    log-lines = 30;

    # When free disk space in /nix/store drops below min-free during a build, Nix performs a
    # garbage-collection until max-free bytes are available or there is no more garbage.
    # A value of 0 (the default) disables this feature.
    min-free = 128000000; # 128 MB
    max-free = 1000000000; # 1 GB

    # If set to true, Nix will fall back to building from source if a binary substitute
    # fails. This is equivalent to the –fallback flag. The default is false.
    fallback = true;

    # Prevent garbage collection from altering nix-shells managed by nix-direnv
    # https://github.com/nix-community/nix-direnv#installation
    keep-outputs = true;
    keep-derivations = true;

    # Automatically detect files in the store that have identical contents, and replaces
    # them with hard links to a single copy. This saves disk space.
    auto-optimise-store = true;

    # Whether to warn about dirty Git/Mercurial trees.
    warn-dirty = false;

    # Allow the use of cachix
    trusted-users = ["root" "aorith"];

    builders-use-substitutes = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}