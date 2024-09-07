{ pkgs, ... }:
let
  bree-index = pkgs.writeTextDir "bree/www/index.html" (builtins.readFile ./bree.html);
  caddyfile = pkgs.writeText "caddyfile" (
    builtins.replaceStrings [ "%%bree_root%%" ] [ "${bree-index.outPath}/bree/www" ] (
      builtins.readFile ./caddyfile
    )
  );
in
{
  services.caddy = {
    enable = true;
    configFile = caddyfile.outPath;
  };
}
