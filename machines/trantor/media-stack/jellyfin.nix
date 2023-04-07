{pkgs, ...}: let
  storage = "/mnt/storage";
  datadir = "${storage}/tank/data/nixos-containers/mediaconfs/jellyfin";
in {
  fileSystems."/MEDIA/movies" = {
    device = "${storage}/disk1/media/movies";
    options = ["bind" "rw"];
  };
  fileSystems."/MEDIA/tv" = {
    device = "${storage}/disk1/media/tv";
    options = ["bind" "rw"];
  };

  users.users."jellyfin" = {
    isNormalUser = true;
    uid = 1013;
    group = "aorith";
    description = "jellyfin";
    extraGroups = ["render" "video"];
    shell = pkgs.bash;
  };

  systemd.services.jellyfin = {
    description = "Jellyfin";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/misc/jellyfin.nix
    serviceConfig = {
      Type = "simple";
      User = "jellyfin";
      Group = "aorith";
      WorkingDirectory = "${datadir}";
      ExecStart = "${pkgs.unstable.jellyfin}/bin/jellyfin --datadir '${datadir}' --configdir '${datadir}/config' --cachedir '/tmp/jellyfin-cache'";
      Restart = "on-failure";
      SuccessExitStatus = ["0" "143"];
      TimeoutSec = 15;
    };
  };
}
