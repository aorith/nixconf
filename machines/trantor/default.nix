{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/users/aorith.nix
    ../../modules/system
    ../../modules/desktop
    ../../modules/virtualisation/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "trantor";
  networking.networkmanager = {
    enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.videoDrivers = ["amdgpu"];

  services.syncthing = {
    enable = true;
    user = "aorith";
    group = "aorith";
    configDir = "/home/aorith/storage/tank/data/syncthing/_config/syncthing";
    dataDir = "/home/aorith/storage/tank/data/syncthing";
    guiAddress = "127.0.0.1:8384";
  };

  system.stateVersion = "22.11";
}
