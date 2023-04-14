{
  pkgs,
  lib,
  ...
}: let
  storage = "/mnt/storage";
in {
  imports = [
    ./hardware.nix
    ./virtualisation.nix
    ./media-stack
    ../../common/users
    ../../common/system
    ../../common/desktop
    ../../common/steam
    ../../common/work
  ];

  aorith.fonts.lowdpi.enable = true;

  hardware.pulseaudio.enable = lib.mkForce false;
  hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
    };
  };

  # from /run/current-system/sw/share/wireplumber/main.lua.d/50-alsa-config.lua
  # disable sound suspend to avoid missing sounds on idle or pop noises
  # pactl list sinks | grep -A1 'State:'
  environment.etc."wireplumber/main.lua.d/51-alsa-custom.lua".text = builtins.readFile ./51-alsa-custom.lua;

  environment.systemPackages = with pkgs; [
    pulseaudio
    unstable.pavucontrol
    unstable.helvum # for pipewire
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
