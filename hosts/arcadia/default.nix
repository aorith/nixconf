{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./fail2ban.nix
    ./caddy.nix
    ./../../modules/system
  ];

  config = {
    # Disable some custom modules
    custom.system.packages = false;

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 7;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "arcadia";
    networking.enableIPv6 = false;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 22000];
    };

    environment.systemPackages = with pkgs; [
      vim
      git
    ];

    services.openssh = {
      enable = true;
      settings.AllowUsers = ["aorith"];
      settings.PermitRootLogin = "prohibit-password";
      settings.PasswordAuthentication = false;
    };

    services = {
      syncthing = {
        enable = true;
        guiAddress = "127.0.0.1:8384";
      };
    };

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        dates = "daily";
        flags = ["--all" "--volumes"];
      };
    };
    users.users.aorith.extraGroups = ["docker"];

    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
