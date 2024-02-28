{...}: {
  imports = [
    ./hardware-configuration.nix
    ./timers.nix
    ./../../modules/system
    ./../../modules/desktop
    ./../../modules/extra/virtualisation.nix
    ./../../modules/te
  ];

  networking.hostName = "trantor";
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;

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

  system.stateVersion = "24.05";
}
