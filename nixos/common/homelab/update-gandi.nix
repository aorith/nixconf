{pkgs, ...}: {
  # Update gandi domain
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
      export PATH="/home/aorith/.nix-profile/bin:$PATH"
      ${pkgs.bash}/bin/bash "/home/aorith/Syncthing/KeePass/iou.re/update-gandi-domain.sh"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
    };
  };

  # Update iou.re wildcard certificate
  systemd.timers."update-iou-re-cert" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "12h";
      Unit = "update-iou-re-cert.service";
    };
  };

  systemd.services."update-iou-re-cert" = {
    script = ''
      cd ~/Syncthing/KeePass/iou.re || exit 1
      export GANDI_LIVEDNS_KEY="$(head -1 apikey)"
      ${pkgs.acme-sh}/bin/acme.sh --register-account -m aomanu@gmail.com || true
      ${pkgs.acme-sh}/bin/acme.sh --issue --dns dns_gandi_livedns -d iou.re -d '*.iou.re' --key-file ./ssl/iou.re.key --fullchain-file ./ssl/iou.re.pem
      cp ./ssl/iou.re.key ~/Syncthing/SYNC_STUFF/githome/virtualisation/odroid/webdav/
      cp ./ssl/iou.re.pem ~/Syncthing/SYNC_STUFF/githome/virtualisation/odroid/webdav/
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aorith";
    };
  };
}
