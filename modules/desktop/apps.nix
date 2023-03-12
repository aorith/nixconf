{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    sublime4
    unstable.alacritty
    unstable.foot
    unstable.rocketchat-desktop
    wl-clipboard
  ];

  services.flatpak.enable = true;
  fonts.fontDir.enable = true; # required for flatpak
}
