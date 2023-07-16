{
  pkgs,
  pkgsFrom,
  ...
}: let
  storage = "/mnt/storage";
  jellyfin_datadir = "${storage}/tank/data/nixos-containers/mediaconfs/jellyfin";

  group = {
    name = "media-stack";
    members = ["media-stack"];
    gid = 1013;
  };
  user = {
    name = "media-stack";
    isNormalUser = true;
    uid = 1013;
    group = "media-stack";
    description = "media-stack";
    extraGroups = ["render" "video"];
    shell = pkgs.bash;
  };
in {
  # user outside of the container
  users.groups."${group.name}" = group;
  users.users."${user.name}" = user;
  users.users.aorith.extraGroups = ["${group.name}"];

  # Jellyfin
  fileSystems."/var/lib/jellyfin" = {
    device = "${jellyfin_datadir}";
    options = ["bind" "rw"];
  };

  systemd.services.jellyfin = {
    description = "Jellyfin";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/misc/jellyfin.nix
    serviceConfig = {
      Type = "simple";
      User = "${user.name}";
      Group = "${group.name}";
      WorkingDirectory = "/var/lib/jellyfin";
      ExecStart = "${pkgsFrom.unstable.jellyfin}/bin/jellyfin --datadir '/var/lib/jellyfin' --cachedir '/tmp/jellyfin-cache'";
      Restart = "on-failure";
      SuccessExitStatus = ["0" "143"];
      TimeoutSec = 15;
    };
  };

  containers.media-stack = {
    autoStart = false;
    privateNetwork = false;
    ephemeral = true;
    nixpkgs = pkgsFrom.unstable.path;

    bindMounts = {
      "/MEDIA" = {
        hostPath = "${storage}/disk1/media";
        isReadOnly = false;
      };
      "/mediaconfs" = {
        hostPath = "${storage}/tank/data/nixos-containers/mediaconfs";
        isReadOnly = false;
      };
      "/var/lib/jellyfin" = {
        hostPath = "${storage}/tank/data/nixos-containers/mediaconfs/jellyfin";
        isReadOnly = false;
      };
      "/var/lib/bazarr" = {
        hostPath = "${storage}/tank/data/nixos-containers/mediaconfs/bazarr";
        isReadOnly = false;
      };
      "/var/lib/transmission/.config/transmission-daemon" = {
        hostPath = "${storage}/tank/data/nixos-containers/mediaconfs/transmission";
        isReadOnly = false;
      };
    };

    config = {
      pkgs,
      nixpkgs,
      ...
    }: {
      # user inside of the container
      users.groups."${group.name}" = group;
      users.users."${user.name}" = user;

      systemd.services.prowlarr = {
        description = "Prowlarr";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = "${user.name}";
          Group = "${group.name}";
          ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=/mediaconfs/prowlarr";
          Restart = "on-failure";
        };
      };

      services = {
        transmission = {
          enable = true;
          user = "${user.name}";
          group = "${group.name}";
          performanceNetParameters = true;
          settings = {
            alt-speed-up = 10;
            alt-speed-down = 150;
            blocklist-enabled = true;
            blocklist-url = "https://github.com/sahsu/transmission-blocklist/releases/latest/download/blocklist.gz";
            rpc-bind-address = "0.0.0.0";
            rpc-whitelist-enabled = false;
            peer-port = 51413;
            incomplete-dir = "/MEDIA/.downloading";
            download-dir = "/MEDIA/downloads";
            download-queue-enabled = true;
            download-queue-size = 3;
            idle-seeding-limit = 15;
            idle-seeding-enabled = true;
            ratio-limit-enabled = true;
            ratio-limit = 0.1;
            umask = 2;
          };
        };
        radarr = {
          enable = true;
          user = "${user.name}";
          group = "${group.name}";
          dataDir = "/mediaconfs/radarr";
        };
        sonarr = {
          enable = true;
          user = "${user.name}";
          group = "${group.name}";
          dataDir = "/mediaconfs/sonarr";
        };
        bazarr = {
          enable = true;
          user = "${user.name}";
          group = "${group.name}";
        };
      };

      boot.kernel.sysctl."net.core.wmem_max" = 1048576; # for transmission
      nixpkgs.config.allowUnfree = true;
      networking = {
        firewall.enable = false;
        enableIPv6 = false;
      };
      environment.etc."resolv.conf".text = "nameserver 8.8.8.8\nnameserver 8.8.4.4";
      system.stateVersion = "22.11";
    };
  };
}
