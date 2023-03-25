{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/users/aorith.nix
    ../../modules/system
    ../../modules/desktop
    ../../modules/virtualisation/docker.nix
    ../../modules/virtualisation/libvirt.nix
    #inputs.private.nixosModules.work
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #services.syncthing = {
  #  enable = true;
  #  user = "aorith";
  #  group = "aorith";
  #  configDir = "/home/aorith/storage/tank/data/syncthing/_config/syncthing";
  #  dataDir = "/home/aorith/storage/tank/data/syncthing";
  #  guiAddress = "127.0.0.1:8384";
  #};

  system.stateVersion = "22.11";
}
