{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    flameshot
    imagemagick
    libreoffice
    mpv
    pavucontrol
    rocketchat-desktop
    sublime4
    unstable.alacritty
    unstable.chromium
    unstable.firefox
    unstable.foot
    vlc
    wl-clipboard
    xclip
  ];

  services.flatpak.enable = true;
  fonts.fontDir.enable = true; # required for flatpak
}
