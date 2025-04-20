{ pkgs, unstable-pkgs, ... }:
{
  services.yarr = {
    enable = true;
    package = unstable-pkgs.yarr;
    envFile = pkgs.writeText "yarr.env" ''
      YARR_ADDR=10.255.254.1:7070
      YARR_AUTHFILE=/etc/yarr.auth
    '';
  };
}
