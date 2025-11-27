{ pkgs, unstable-pkgs, ... }:
{
  services.caddy = {
    enable = true;
    configFile = ./Caddyfile;
    package = unstable-pkgs.caddy;
  };
}
