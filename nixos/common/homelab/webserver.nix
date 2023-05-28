{...}: {
  services.nginx = {
    enable = true;
    virtualHosts."bree.iou.re" = {
      root = "/home/aorith/Syncthing/SYNC_STUFF/githome/virtualisation/odroid/nginx/bree/www";
    };
  };
}
