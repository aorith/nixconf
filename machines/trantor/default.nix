{...}: {
  imports = [
    ./hardware.nix
    ./virtualisation.nix
    ./justfile.nix
    ../../modules/users/aorith.nix
    ../../modules/system
    ../../modules/desktop
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

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  services = {
    syncthing = {
      enable = true;
      user = "aorith";
      group = "aorith";
      configDir = "/home/aorith/storage/tank/data/syncthing/_config/syncthing";
      dataDir = "/home/aorith/storage/tank/data/syncthing";
      guiAddress = "127.0.0.1:8384";
    };
    fwupd.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
  };

  systemd.tmpfiles.rules = [
    "L /home/aorith/Syncthing - - - - /home/aorith/storage/tank/data/syncthing"
    "L /run/current-system/sw/share/X11/fonts - - - - /home/aorith/.local/share/fonts"
  ];

  system.stateVersion = "22.11";
}
