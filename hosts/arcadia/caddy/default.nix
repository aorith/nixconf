{
  pkgs,
  config,
  unstable-pkgs,
  ...
}:
let
  caddyfile = pkgs.replaceVars ./Caddyfile {
    CERT_PATH = "${config.security.acme.certs."iou.re".directory}/cert.pem";
    KEY_PATH = "${config.security.acme.certs."iou.re".directory}/key.pem";
  };
in
{

  security.acme = {
    acceptTerms = true;
    defaults.email = "aomanu+acme@gmail.com";

    certs."iou.re" = {
      domain = "*.iou.re";
      dnsProvider = "gandiv5";
      environmentFile = "/etc/gandi-api-token.env";
      group = "caddy";
      reloadServices = [ "caddy.service" ];
    };
  };

  users.users.caddy.extraGroups = [ "acme" ];

  services.caddy = {
    enable = true;
    configFile = caddyfile;
    package = unstable-pkgs.caddy;
  };
}
