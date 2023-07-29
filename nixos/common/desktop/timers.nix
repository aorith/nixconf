{pkgs, ...}: {
  # Clean old images from screenshots folder
  systemd = {
    timers."clean-screenshots-folder" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "12h";
        Unit = "clean-screenshots-folder.service";
      };
    };
    services."clean-screenshots-folder" = {
      script = ''
        ${pkgs.findutils}/bin/find "$HOME/Pictures/Screenshots" -type f -mtime +30 -delete
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "aorith";
      };
    };
  };
}
