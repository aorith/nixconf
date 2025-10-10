{ pkgs, lib, ... }:
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

    # EXPERIMENTAL
    # I2P (Invisible Internet Project) is an anonymous, decentralized overlay network.
    # It routes traffic inside its own encrypted network of peers
    i2pd = {
      enable = true;
      port = 10100; # UDP - open it optionally
      proto = {
        http = {
          # Web interface
          enable = true;
          address = "10.255.255.8";
          port = 10101;
        };
        httpProxy = {
          # Test: curl "http://notbob.i2p" --proxy 10.255.255.8:10102
          enable = true;
          address = "10.255.255.8";
          port = 10102;
          # NOTE: outproxy: Address of a proxy server inside I2P, which is used to visit regular Internet
          # outproxy = "http://false.i2p";
        };
        sam = {
          enable = true;
          port = 10103;
        };
      };
    };

  };
}
