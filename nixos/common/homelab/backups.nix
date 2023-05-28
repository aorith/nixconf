{pkgs, ...}: {
  # Backup keepass
  systemd.timers."backup-keepass" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "12h";
      Unit = "backup-keepass.service";
    };
  };

  systemd.services."backup-keepass" = {
    script = ''
      backup_date=$(${pkgs.coreutils}/bin/date +'%Y%m%d%H%M%S')
      cp ~/Syncthing/KeePass/0DB/main.kdbx ~/Syncthing/KeePass/0DB/Backups/main_''${backup_date}.kdbx
      ${pkgs.findutils}/bin/find ~/Syncthing/KeePass/0DB/Backups/ -type f -name "*.kdbx" -mtime +60 -delete
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
    };
  };

  # Backup joplin
  systemd.timers."backup-joplin" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      Unit = "backup-joplin.service";
    };
  };

  systemd.services."backup-joplin" = {
    script = ''
      export PATH="$PATH:${pkgs.gzip}/bin"
      ${pkgs.gnutar}/bin/tar -cvzf ~/Syncthing/SYNC_STUFF/JOPLIN/backups/all_$(date +'%Y%m%d%H%M%S').tar.gz ~/Syncthing/SYNC_STUFF/JOPLIN/current
      ${pkgs.findutils}/bin/find ~/Syncthing/SYNC_STUFF/JOPLIN/backups/ -type f -name "*.tar.gz" -mtime +30 -delete
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
    };
  };
}
