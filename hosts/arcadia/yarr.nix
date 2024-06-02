{ pkgs, unstable-pkgs, ... }:
{
  services.yarr = {
    enable = true;
    package = unstable-pkgs.yarr;
    envFile = pkgs.writeText "yarr.env" ''
      YARR_ADDR=127.0.0.1:7070
      YARR_AUTHFILE=/etc/yarr.auth
    '';
  };
}
