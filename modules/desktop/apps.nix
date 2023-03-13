{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rocketchat-desktop
    sublime4
    unstable.alacritty
    unstable.chromium
    unstable.firefox
    unstable.foot
    wl-clipboard
  ];

  services.flatpak.enable = true;
  fonts.fontDir.enable = true; # required for flatpak
}
