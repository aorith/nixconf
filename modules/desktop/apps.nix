{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    imagemagick
    pavucontrol
    sublime4
    unstable.alacritty
    wl-clipboard
    xclip
  ];
}
