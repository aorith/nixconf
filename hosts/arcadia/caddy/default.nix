{ pkgs, unstable-pkgs, ... }:
let
  bree-index = pkgs.writeTextDir "bree/www/index.html" (builtins.readFile ./bree.html);
  caddyfile = pkgs.writeText "Caddyfile" (
    builtins.replaceStrings [ "%%bree_root%%" ] [ "${bree-index.outPath}/bree/www" ] (
      builtins.readFile ./Caddyfile
    )
  );
in
{
  services.caddy = {
    enable = true;
    configFile = caddyfile.outPath;
    package = unstable-pkgs.caddy;
  };
}
