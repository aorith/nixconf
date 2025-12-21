{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /srv/www 0755 root root -"
  ];

  # 5-minute graph - every 15 minutes
  systemd.timers."vnstati-5m-graph" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "15m";
      Unit = "vnstati-5m-graph.service";
    };
  };
  systemd.services."vnstati-5m-graph" = {
    path = with pkgs; [ vnstat ];
    script = ''
      ${pkgs.vnstat}/bin/vnstati -i enp1s0 -5g -o /srv/www/5m-graph.png
      ${pkgs.vnstat}/bin/vnstati -i wg0 -5g -o /srv/www/wg0-5m-graph.png
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Hourly/Monthly graph - every hour
  systemd.timers."vnstati-hourly" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1h";
      Unit = "vnstati-hourly.service";
    };
  };
  systemd.services."vnstati-hourly" = {
    path = with pkgs; [ vnstat ];
    script = ''
      ${pkgs.vnstat}/bin/vnstati -i enp1s0 -h 24 -o /srv/www/hourly.png
      ${pkgs.vnstat}/bin/vnstati -i enp1s0 -m 12 -o /srv/www/monthly.png
      ${pkgs.vnstat}/bin/vnstati -i wg0 -h 24 -o /srv/www/wg0-hourly.png
      ${pkgs.vnstat}/bin/vnstati -i wg0 -m 12 -o /srv/www/wg0-monthly.png
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Summary - every hour
  systemd.timers."vnstati-summary" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1h";
      Unit = "vnstati-summary.service";
    };
  };
  systemd.services."vnstati-summary" = {
    path = with pkgs; [ vnstat ];
    script = ''
      ${pkgs.vnstat}/bin/vnstati -i enp1s0 -s -o /srv/www/summary.png
      ${pkgs.vnstat}/bin/vnstati -i wg0 -s -o /srv/www/wg0-summary.png
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Keepass backups
  systemd.timers."backup-keepass" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "20h";
      Unit = "backup-keepass.service";
    };
  };
  systemd.services."backup-keepass" = {
    path = with pkgs; [
      vnstat
      gawk
      openssl
      findutils
    ];
    script = ''
      #!/bin/sh
      set -ex

      keepass_dir="$HOME/Syncthing/KeePass/0DB"
      if [ ! -d "$keepass_dir" ]; then
          keepass_dir="/var/lib/syncthing/KeePass/0DB"
      fi
      if [ ! -d "$keepass_dir" ]; then
          exit 1
      fi

      command -v openssl >/dev/null || exit 1

      backup_date=$(date +'%Y%m%d%H%M%S')
      sum=$(openssl sha256 "$keepass_dir/main.kdbx" | awk '{print $NF}' | head -1)

      find "$keepass_dir/Backups/" -type f -regex ".*/main_.*_''${sum}\.kdbx"
      if find "$keepass_dir/Backups/" -type f -regex ".*/main_.*_''${sum}\.kdbx" -print0 | grep -q '^'; then
          echo "Backup for ''${sum} already exists."
      else
          echo "Saving backup for ''${sum}."
          cp -v "$keepass_dir/main.kdbx" "$keepass_dir/Backups/main_''${backup_date}_''${sum}.kdbx"
      fi

      # keep only 60 backups
      find "$keepass_dir/Backups/" -name '*.kdbx' -type f -printf '%T@ %p\n' | sort -rn | tail -n +60 | awk '{print $NF}' | xargs --no-run-if-empty rm
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "syncthing";
      Group = "syncthing";
    };
  };
}
