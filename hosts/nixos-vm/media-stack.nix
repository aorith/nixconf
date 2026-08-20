{ pkgs, ... }:
let
  user = {
    name = "media-stack";
    uid = 1013;
  };
  group = {
    name = "media-stack";
    gid = 1013;
  };
in
{
  users.groups."${group.name}" = {
    members = [ "${user.name}" ];
    gid = group.gid;
  };
  users.users."${user.name}" = {
    isNormalUser = true;
    uid = user.uid;
    group = "${group.name}";
    description = "${user.name}";
    extraGroups = [
      "systemd-journal"
      "render"
      "video"
    ];
    shell = pkgs.bash;
    initialHashedPassword = "$6$nZjdJqbWrot/3qp1$gxUvzKo0o.6bjLmZqdifRXLDuilPFkzfl7rG7MNKH0HYY6R.d.lKIzo9V18vIOw6bPx46vUEbkWIWbgCPF2L11";
  };

  services = {
    jellyfin = {
      enable = true;
      user = user.name;
      group = group.name;
    };

    qbittorrent = {
      enable = true;
      user = user.name;
      group = group.name;
    };

    prowlarr = {
      enable = true;
    };

    radarr = {
      enable = true;
      user = "${user.name}";
      group = "${group.name}";
    };

    sonarr = {
      enable = true;
      user = "${user.name}";
      group = "${group.name}";
    };

    bazarr = {
      enable = true;
      user = "${user.name}";
      group = "${group.name}";
    };

    amule = {
      enable = true;
      user = "${user.name}";
      group = "${group.name}";
      ExternalConnectPasswordFile = "/home/${user.name}/.amule-ec-passwd";
      WebServerPasswordFile = "/home/${user.name}/.amule-ec-passwd";
      settings = {
        WebServer = {
          Enabled = 1;
          Port = 4711;
        };

        eMule = {
          TempDir = "/mnt/disk1/media/.downloading-amule";
          IncomingDir = "/mnt/disk1/media/downloads";
        };
      };
    };

    # EXPERIMENTAL
    # I2P (Invisible Internet Project) is an anonymous, decentralized overlay network.
    # It routes traffic inside its own encrypted network of peers
    i2pd = {
      enable = false;

      settings = {
        port = 10100; # UDP - open it optionally

        http = {
          # Web interface
          enabled = true;
          address = "10.255.255.8";
          port = 10101;
        };
        httpproxy = {
          # Test: curl "http://notbob.i2p" --proxy 10.255.255.8:10102
          enabled = true;
          address = "10.255.255.8";
          port = 10102;
          # NOTE: outproxy: Address of a proxy server inside I2P, which is used to visit regular Internet
          # outproxy = "http://false.i2p";
        };
        sam = {
          enabled = true;
          port = 10103;
        };
      };
    };

  };
}
