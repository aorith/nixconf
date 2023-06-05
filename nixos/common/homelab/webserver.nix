{pkgs, ...}: {
  services.nginx = {
    enable = true;
    virtualHosts."bree.iou.re" = let
      rootDir = pkgs.writeTextDir "www/index.html" (builtins.readFile ./index.html);
    in {
      root = "${rootDir}/www";
    };
  };
}
