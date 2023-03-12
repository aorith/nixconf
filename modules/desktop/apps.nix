{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    unstable.alacritty
  ];

  services.flatpak.enable = true;
  fonts.fontDir.enable = true; # required for flatpak
}
