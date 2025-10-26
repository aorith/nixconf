{ inputs, pkgs, ... }:
let
  tls-cert =
    {
      alt ? [ ],
    }:
    (pkgs.runCommand "selfSignedCert" { buildInputs = [ pkgs.openssl ]; } ''
      mkdir -p $out
      openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 -days 365 -nodes \
        -keyout $out/cert.key -out $out/cert.crt \
        -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,${
          builtins.concatStringsSep "," (
            [
              "IP:127.0.0.1"
              "IP:10.255.254.1"
            ]
            ++ alt
          )
        }"
    '');

  cert = tls-cert {
    alt = [
      "DNS:notes.iou.re"
      "DNS:silverbullet.iou.re"
      "DNS:yarr.iou.re"
      "DNS:dav.iou.re"
    ];
  };
in
{
  # Used to serve some apps via HTTPS
  # for example to allow clipboard functionality
  services.nginx = {
    enable = true;

    config = ''
      worker_processes auto;
      events {
        worker_connections 1024;
      }

      error_log stderr;

      http {
          include       "${pkgs.mailcap}/etc/nginx/mime.types";
          default_type  application/octet-stream;

          sendfile        on;
          keepalive_timeout  65;
          server_tokens off;

          access_log off;
          error_log stderr;

          gzip on;
          gzip_comp_level 5;
          gzip_min_length 256;
          gzip_proxied any;
          gzip_types
              text/plain
              text/css
              application/json
              application/javascript
              text/xml
              application/xml
              application/xml+rss
              text/javascript;

          ssl_protocols TLSv1.3 TLSv1.2;
          ssl_prefer_server_ciphers on;
          ssl_session_cache shared:SSL:10m;
          ssl_session_timeout 10m;

          types_hash_max_size 8192;

          ssl_certificate "${cert}/cert.crt";
          ssl_certificate_key "${cert}/cert.key";

          server {
              listen 10.255.254.1:7676 ssl;
              server_name notes.iou.re;

              location / {
                  proxy_pass http://127.0.0.1:8323/;
                  proxy_set_header Host $host:$server_port;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Port $server_port;
                  proxy_set_header X-Forwarded-Proto $scheme;
              }
          }

          server {
              listen 10.255.254.1:7676 ssl;
              server_name silverbullet.iou.re;

              location / {
                  proxy_pass http://127.0.0.1:3000/;
                  proxy_set_header Host $host:$server_port;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Port $server_port;
                  proxy_set_header X-Forwarded-Proto $scheme;
              }
          }

          server {
              listen 10.255.254.1:7676 ssl;
              server_name yarr.iou.re;

              location / {
                  proxy_pass http://127.0.0.1:7070/;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Port $server_port;
                  proxy_set_header X-Forwarded-Proto $scheme;
              }
          }

          server {
              listen 10.255.254.1:7676 ssl;
              server_name dav.iou.re;
              location / {
                return 200 'webdav servers are on subpaths';
                add_header Content-Type 'text/html';
              }

              location /joplin {
                  proxy_pass http://127.0.0.1:7777/joplin/;
                  proxy_set_header Host $host:$server_port;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Port $server_port;
                  proxy_set_header X-Forwarded-Proto $scheme;
              }
          }
      }
    '';
  };
}
