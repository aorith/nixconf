{
  config,
  pkgs,
  lib,
  ...
}: let
  mkOptionEnabled = name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to evaluate system/${name}.nix.";
      type = lib.types.bool;
    };
in {
  options.custom.system = {
    nix = mkOptionEnabled "nix";
    packages = mkOptionEnabled "packages";
    shell = mkOptionEnabled "shell";
    ssh = mkOptionEnabled "ssh";
    users = mkOptionEnabled "users";
  };

  imports = [
    ./nix.nix
    ./packages.nix
    ./shell.nix
    ./ssh.nix
    ./users.nix
  ];

  config = {
    # Generate hostId from the hostname
    networking.hostId = builtins.substring 24 8 (builtins.hashString "md5" "${config.networking.hostName}");

    boot.tmp.useTmpfs = true;

    time.timeZone = "Europe/Madrid";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = ["C.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "es_ES.UTF-8/UTF-8"];
    console = {
      font = "Lat2-Terminus16";
      keyMap = lib.mkForce "es";
      useXkbConfig = true;
    };

    services.journald.extraConfig = ''
      SystemMaxUse=1G
    '';

    # Allow editing /etc/hosts as root (changes are discarded on rebuild)
    environment.etc.hosts.mode = "0644";

    # Diff between system rebuilds
    system.activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.coreutils}/bin/cat <<-EOF

              +: Package is newly selected in environment.systemPackages.
              -: Package is newly unselected.
              *: Package is selected; state unchanged.
              .: Package is not selected; it's a dependency.

        EOF

        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
        echo
      '';
    };

    # Packages available on all systems
    environment.systemPackages = with pkgs; [
      vim

      nix-output-monitor
      nvd # nix package version diff tool
      nix-index # find which derivation provides a file (nix-index && nix-locate libc.so.6)
    ];
  };
}
