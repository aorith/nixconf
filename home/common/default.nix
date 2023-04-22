{pkgsFrom, ...}: {
  home.packages = [
    pkgsFrom.unstable.just
  ];

  xdg.mime.enable = true;
}
