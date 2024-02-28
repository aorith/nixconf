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
    script = ''
      export PATH="/home/aorith/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
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
    script = ''
      export PATH="/home/aorith/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
      ${pkgs.bash}/bin/bash "/home/aorith/githome/dotfiles/topics/systemd/keepass/backup-keepass.sh"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
      Group = "aorith";
    };
  };
}
