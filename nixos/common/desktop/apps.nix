{
  pkgs,
  pkgsFrom,
  ...
}: {
  environment.systemPackages = with pkgs; [
    pkgsFrom.unstable.alacritty
    pkgsFrom.unstable.mpv
    pkgsFrom.unstable.ungoogled-chromium
    pkgsFrom.unstable.wezterm

    imagemagick
    sublime4
    wl-clipboard
    xclip
  ];
}
