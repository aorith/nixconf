{pkgs, ...}: {
  # Gandi
  systemd.timers."update-gandi-domain" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "12h";
      Unit = "update-gandi-domain.service";
    };
  };
  systemd.services."update-gandi-domain" = {
    path = with pkgs; [bash terraform jq curl];
    script = ''
      ${pkgs.bash}/bin/bash "/home/aorith/Syncthing/KeePass/iou.re/update-gandi-domain.sh"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
      Group = "aorith";
    };
  };

  # KeePass
  systemd.timers."backup-keepass" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "12h";
      Unit = "backup-keepass.service";
    };
  };
  systemd.services."backup-keepass" = {
    path = with pkgs; [bash coreutils gawk findutils gnugrep];
    script = ''
      ${pkgs.bash}/bin/bash "/home/aorith/githome/dotfiles/topics/systemd/keepass/backup-keepass.sh"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
      Group = "aorith";
    };
  };
}
