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
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
