{ config, pkgs, ... }:
let
  root = "/var/lib/syncthing/SYNC_STUFF/webdav/joplin";
in
{
  systemd.services.rclone-webdav-joplin = {
    description = "Rclone WebDAV Joplin";
    after = [
      "network.target"
      "syncthing.service"
    ];
    wantedBy = [ "multi-user.target" ];

    unitConfig = {
      # See syncthing service
      ConditionPathExists = "/var/lib/syncthing/luks-mounted";
    };

    serviceConfig = {
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone serve webdav \
        --user 1234 --pass 1234 \
        --baseurl joplin \
        --log-level WARNING \
        --addr 127.0.0.1:7777 ${root}
      '';
      User = "syncthing";
      Group = "syncthing";
      Restart = "on-failure";
      RestartSec = "5s";
      WorkingDirectory = "${root}";

      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateUsers = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };
}
