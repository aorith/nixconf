{pkgsFrom, ...}: {
  home.packages = [
    pkgsFrom.unstable.wezterm
    pkgsFrom.unstable.alacritty
  ];
}
