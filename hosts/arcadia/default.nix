{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./fail2ban.nix
    ./caddy
    ./syncthing.nix
    ./wireguard.nix
    ./proxy.nix
    ./../../modules/nixos/core
    ./../../modules/nixos/optional/extra/yarr.nix
    ./yarr.nix
    ./silverbullet.nix
    ./webdav.nix
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

    environment.systemPackages = with pkgs; [
      git
      gnumake
      vim
    ];

    services.openssh = {
      enable = true;
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
