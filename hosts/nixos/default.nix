{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/core
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useNetworkd = true;
    useDHCP = false;
    useHostResolvConf = false;
    firewall.enable = false;
    enableIPv6 = false;
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    address = [
      "10.255.255.8/24"
    ];
    routes = [
      { routeConfig.Gateway = "10.255.255.1"; }
    ];
    # make the routes on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
  };

  environment.systemPackages = with pkgs; [
    inputs.neovim-flake.packages.${pkgs.system}.default
    gnumake
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
