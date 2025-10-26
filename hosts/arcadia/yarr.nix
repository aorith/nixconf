{ pkgs, unstable-pkgs, ... }:
{
  services.yarr = {
    enable = true;
    package = unstable-pkgs.yarr;
    address = "127.0.0.1";
    port = 7070;
    #authFilePath = "/etc/yarr.auth";
  };
}
