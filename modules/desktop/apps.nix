{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    imagemagick
    sublime4
    unstable.alacritty
    unstable.mpv
    unstable.ungoogled-chromium
    unstable.wezterm
    wl-clipboard
    xclip
  ];
}
