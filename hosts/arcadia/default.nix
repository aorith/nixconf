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
    ./varnishlog-parser.nix
    ./nginx.nix
    ./whoami.nix
    ./timers.nix
    ./victoriametrics.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 7;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "arcadia";
    networking.enableIPv6 = false;
    networking.nftables = {
      enable = true;
      tables = {
        portmon = {
          name = "portmon";
          enable = true;
          family = "inet";
          content = ''
            set whitelist4 {
              type ipv4_addr
              flags interval # cidr ranges
              elements = { 127.0.0.1/24, 10.255.254.0/24, 172.17.0.0/16, 172.18.0.0/16 }
            }

            set ban4 {
              type ipv4_addr
              flags timeout
              timeout 8h
            }

            chain input {
                type filter hook input priority -10

                ip saddr @ban4 drop
                meta l4proto { tcp, udp } th dport { 22, 3306 } ip saddr != @whitelist4 add @ban4 { ip saddr } drop
            }
          '';
        };
      };
    };
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
      extraOptions = "--iptables=False --firewall-backend=nftables";
      extraPackages = [ pkgs.nftables ];
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
