{
  pkgs,
  pkgsFrom,
  ...
}: {
  environment.systemPackages = with pkgs; [
    pkgsFrom.unstable.mpv
    pkgsFrom.unstable.ungoogled-chromium

    imagemagick
    sublime4
    wl-clipboard
    xclip
  ];
}
