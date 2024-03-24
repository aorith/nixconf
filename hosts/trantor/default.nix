{
  imports = [
    ./hardware-configuration.nix
    ./timers.nix
    ./../../modules/nixos/core
    ./../../modules/nixos/optional/desktop
    ./../../modules/nixos/optional/extra/virtualisation.nix
    ./../../modules/nixos/optional/te
    ./../../modules/nixos/optional/home-manager.nix
  ];

  home-manager.users.aorith = import ./home.nix;

  networking.hostName = "trantor";
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
  networking.firewall.enable = false;

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
  systemd.tmpfiles.rules = [
    "L /home/aorith/Syncthing - - - - /mnt/storage/tank/data/syncthing"
  ];

  programs.adb.enable = true;
  users.users.aorith.extraGroups = ["adbusers"];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}
