{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/core
    ./fail2ban.nix
    ./caddy
    ./syncthing.nix
    ./wireguard.nix
    ./proxy.nix
    ./yarr.nix
    ./silverbullet.nix
    ./varnishlog-parser.nix
    ./nginx.nix
    ./notes.nix
    ./whoami.nix
    ./webdav.nix
    ./timers.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 7;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "arcadia";
    networking.enableIPv6 = false;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        22022
        80
        443
      ];
      logRefusedConnections = false; # Reduce journal logs
    };

    services.cron.enable = true;
    services.vnstat.enable = true;

    services.openssh = {
      enable = true;
      openFirewall = false;
      settings.AllowUsers = [ "aorith" ];
      settings.PermitRootLogin = "prohibit-password";
      settings.PasswordAuthentication = false;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 22022;
        }
      ];
    };

    users.users.aorith.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmfktrz3eMNZ6aVJcvFC4ABOwMvS3g0gVuCAQKMwDSl aorith@msp"
      # Termux:
      "from=\"10.255.254.0/24\" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNYo2UDjYeGnvf8WhyAIh7AnAEI5NNXchgibAZXcnks u0_a480@localhost"
    ];

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        dates = "daily";
        flags = [
          "--all"
          "--volumes"
        ];
      };
    };
    users.users.aorith.extraGroups = [ "docker" ];

    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
