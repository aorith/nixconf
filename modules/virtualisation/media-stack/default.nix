{pkgs, ...}: {
  containers.media-stack = {
    autoStart = false;
    privateNetwork = false;
    ephemeral = true;
    nixpkgs = pkgs.unstable.path;

    bindMounts = {
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = true;
      };
      "/MEDIA" = {
        hostPath = "/storage/disk1/media";
        isReadOnly = false;
      };
      "/mediaconfs" = {
        hostPath = "/storage/tank/data/nixos-containers/mediaconfs";
        isReadOnly = false;
      };
      "/var/lib/jellyfin" = {
        hostPath = "/storage/tank/data/nixos-containers/mediaconfs/jellyfin";
        isReadOnly = false;
      };
      "/var/lib/bazarr" = {
        hostPath = "/storage/tank/data/nixos-containers/mediaconfs/bazarr";
        isReadOnly = false;
      };
      "/var/lib/transmission/.config/transmission-daemon" = {
        hostPath = "/storage/tank/data/nixos-containers/mediaconfs/transmission";
        isReadOnly = false;
      };
    };

    config = {
      pkgs,
      nixpkgs,
      ...
    }: {
      users.groups = {
        "media-stack" = {
          members = ["media-stack"];
          gid = 1000;
        };
      };
      users.users."media-stack" = {
        isNormalUser = true;
        uid = 1000;
        group = "media-stack";
        description = "media-stack";
        shell = pkgs.bash;
      };

      services = {
        jellyfin = {
          enable = true;
          user = "media-stack";
          group = "media-stack";
        };
        transmission = {
          enable = true;
          user = "media-stack";
          group = "media-stack";
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
        jackett = {
          enable = true;
          user = "media-stack";
          group = "media-stack";
          dataDir = "/mediaconfs/jackett";
        };
        radarr = {
          enable = true;
          user = "media-stack";
          group = "media-stack";
          dataDir = "/mediaconfs/radarr";
        };
        sonarr = {
          enable = true;
          user = "media-stack";
          group = "media-stack";
          dataDir = "/mediaconfs/sonarr";
        };
        bazarr = {
          enable = true;
          user = "media-stack";
          group = "media-stack";
        };
      };

      boot.kernel.sysctl."net.core.wmem_max" = 1048576; # for transmission
      nixpkgs.config.allowUnfree = true;
      networking.firewall.enable = false;
      environment.etc."resolv.conf".text = "nameserver 8.8.8.8\nnameserver 8.8.4.4";
      system.stateVersion = "22.11";
    };
  };
}
