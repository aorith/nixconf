{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/core
    ./../../modules/nixos/optional/desktop
    ./../../modules/nixos/optional/neovim.nix
  ];

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "alpaca";
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
  networking.firewall.enable = false;

  services = {
    syncthing = {
      enable = true;
      user = "aorith";
      group = "aorith";
      dataDir = "/home/aorith/Syncthing";
      guiAddress = "127.0.0.1:8384";
    };
  };
  systemd.tmpfiles.rules = [ "L /home/aorith/Syncthing - - - - /mnt/data/syncthing" ];

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
