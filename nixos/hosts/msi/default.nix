{
  pkgs,
  lib,
  ...
}: let
  storage = "/mnt/data";
in {
  imports = [
    ./hardware.nix
    ../../common/users
    ../../common/system
    ../../common/desktop
    #../../common/steam
  ];

  nix.settings.max-jobs = lib.mkDefault 8;

  hardware.steam-hardware.enable = true;

  hardware.pulseaudio.enable = lib.mkForce false;
  hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    helvum # for pipewire
    pulseaudio
  ];

  services = {
    syncthing = {
      enable = true;
      user = "aorith";
      group = "aorith";
      configDir = "${storage}/tank/data/syncthing/_config/syncthing";
      dataDir = "${storage}/tank/data/syncthing";
      guiAddress = "127.0.0.1:8384";
    };
    fwupd.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
  };

  systemd.tmpfiles.rules = [
    "L /home/aorith/Syncthing - - - - ${storage}/tank/data/syncthing"
  ];

  system.stateVersion = "22.11";
}
