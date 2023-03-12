{...}: {
  imports = [
    ./fonts.nix
    ./apps.nix
    ./gnome.nix
  ];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
