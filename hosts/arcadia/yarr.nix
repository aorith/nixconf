{ pkgs, unstable-pkgs, ... }:
{
  services.yarr = {
    enable = true;
    package = unstable-pkgs.yarr;
    address = "10.255.254.1";
    port = 7070;
    #authFilePath = "/etc/yarr.auth";
  };
}
