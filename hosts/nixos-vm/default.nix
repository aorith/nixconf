{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos/core
    ./../../modules/nixos/optional/desktop
    ./syncthing.nix
    ./media-stack.nix
  ];

  environment.systemPackages = [
    inputs.neovim-flake.packages.${pkgs.stdenv.hostPlatform.system}.vanilla
    pkgs.awscli2
    pkgs.kubectl
    pkgs.kubecolor
    pkgs.openvpn
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking = {
    hostName = "nixos-vm";
    networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openvpn
      ];
    };
    useNetworkd = true;
    useDHCP = false;
    useHostResolvConf = false;
    firewall.enable = false;
    enableIPv6 = false;

    wg-quick.interfaces = {
      wg0.configFile = "/etc/wireguard-keys/nixos-vm.conf";
    };
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens18";
    address = [
      "10.255.255.8/24"
    ];
    routes = [
      { Gateway = "10.255.255.1"; }
    ];
    # make the routes on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
  };

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  system.stateVersion = "25.05";
}
