{pkgs, ...}: {
  services.caddy = {
    enable = true;
    configFile = pkgs.writeText "Caddyfile" ''
      notes.iou.re {
        tls aomanu+caddy@gmail.com
        bind 0.0.0.0

        log notes {
          level INFO
          format json
          output file /var/log/caddy/notes.log {
            roll_size 50MiB
            roll_keep 10
            roll_keep_for 196h
          }
        }

        reverse_proxy 127.0.0.1:3000 {
          header_down Strict-Transport-Security max-age=31536000;
        }
      }
    '';
  };
}
