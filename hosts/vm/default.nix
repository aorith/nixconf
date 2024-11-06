{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/core
    ./../../modules/nixos/optional/desktop
  ];

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  networking.hostName = "vm";
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}
