{
  imports = [
    ./hardware-configuration.nix
    ./timers.nix
    ./../../modules/nixos/core
    ./../../modules/nixos/optional/desktop
    ./../../modules/nixos/optional/extra/virtualisation.nix
    ./../../modules/nixos/optional/extra/steam.nix
    ./../../modules/nixos/optional/te
  ];

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "trantor";
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    settings.AllowUsers = [ "aorith" ];
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
    listenAddresses = [
      {
        addr = "10.255.255.7";
        port = 22;
      }
    ];
  };

  services = {
    syncthing = {
      enable = true;
      user = "aorith";
      group = "aorith";
      configDir = "/mnt/storage/tank/data/syncthing/_config/syncthing";
      dataDir = "/mnt/storage/tank/data/syncthing";
      guiAddress = "10.255.255.7:8384";
    };
  };
  systemd.tmpfiles.rules = [ "L /home/aorith/Syncthing - - - - /mnt/storage/tank/data/syncthing" ];

  programs.adb.enable = true;
  users.users.aorith.extraGroups = [ "adbusers" ];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}
