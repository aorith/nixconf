{ inputs, pkgs, ... }:
let
  nginxConfig = pkgs.writeText "nginx.conf" ''
    daemon off;
    user nobody nobody;
    events {}
    error_log /dev/stdout info;
    pid /dev/null;
    http {
      include ${pkgs.nginx}/conf/mime.types;
      server {
        listen 8080 default_server;
        root /data/pub/;
        location / {
          alias /data/pub/;
          autoindex on;
        }
      }
      server {
        listen 8081;
        client_max_body_size 200M;
        location / {
          auth_basic "Files";
          auth_basic_user_file /etc/auth.config;
          proxy_pass http://127.0.0.1:7777;
        }
      }
    }
  '';

  startScript = pkgs.writeShellScriptBin "startScript" ''
    #!${pkgs.bash}
    set -xeu -o pipefail
    ${pkgs.apacheHttpd}/bin/htpasswd -nb "$AUTH_USER" "$AUTH_PASSWORD" > /etc/auth.config
    ${pkgs.rclone}/bin/rclone serve webdav --log-level WARNING --addr 127.0.0.1:7777 /data/ &
    ${pkgs.nginx}/bin/nginx -c ${nginxConfig} &
    wait -n
    exit $?
  '';
  rcloneWebdavImage = pkgs.dockerTools.buildLayeredImage {
    name = "rclone-webdav";
    tag = "latest";
    created = builtins.substring 0 8 inputs.self.lastModifiedDate;

    contents = [ pkgs.fakeNss ];

    extraCommands = ''
      mkdir -p srv/client-temp
      mkdir -p var/log/nginx/
      mkdir -p tmp/nginx_client_body
    '';

    config = {
      ExposedPorts = {
        "8080/tcp" = { };
        "8081/tcp" = { };
      };
      Entrypoint = [ "${startScript}/bin/startScript" ];
      Cmd = [ ];
    };
  };
in
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      webdav = {
        autoStart = true;
        image = "${rcloneWebdavImage.imageName}:${rcloneWebdavImage.imageTag}";
        imageFile = rcloneWebdavImage;
        environmentFiles = [
          /etc/webdav.env # AUTH_USER and AUTH_PASSWORD
        ];
        ports = [
          "127.0.0.1:8101:8080"
          "127.0.0.1:8102:8081"
        ];
      };
    };
  };

}
