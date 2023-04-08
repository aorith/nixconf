{pkgs, ...}: let
  storage = "/mnt/data";
in {
  imports = [
    ./hardware.nix
    ../../modules/users
    ../../modules/system
    ../../modules/desktop
    ../../modules/steam
  ];

  hardware.pulseaudio.enable = false;
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

  environment.systemPackages = with pkgs; [
    unstable.pavucontrol
    unstable.helvum # for pipewire
  ];

  # from /run/current-system/sw/share/wireplumber/main.lua.d/50-alsa-config.lua
  # disable sound suspend to avoid missing sounds on idle or pop noises
  environment.etc."wireplumber/main.lua.d/51-alsa-custom.lua".text = ''
    alsa_monitor.rules = {
      {
        matches = {
          {
            -- Matches all sources.
            { "node.name", "matches", "alsa_input.*" },
          },
          {
            -- Matches all sinks.
            { "node.name", "matches", "alsa_output.*" },
          },
        },
        apply_properties = {
          ["session.suspend-timeout-seconds"] = 0, -- 0 disables suspend
        },
      },
    }

  '';

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
