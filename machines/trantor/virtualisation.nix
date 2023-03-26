{
  lib,
  pkgs,
  ...
}: let
  enable_podman = true;
  enable_libvirt = true;
in {
  environment.systemPackages = [
    pkgs.virt-manager
    (lib.mkIf enable_podman pkgs.podman-compose)
  ];

  users.users.aorith.extraGroups = [
    (lib.mkIf (!enable_podman) "docker")
    (lib.mkIf enable_libvirt "libvirtd")
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      onBoot = "ignore";
      allowedBridges = ["br0" "virbr0"];
      qemu = {
        ovmf.enable = true;
      };
    };
    docker = {
      enable = !enable_podman;
      storageDriver = "btrfs";
      autoPrune = {
        dates = "daily";
        flags = ["--all" "--volumes"];
      };
    };

    podman = {
      enable = enable_podman;
      defaultNetwork.dnsname.enable = true;
    };
  };
}
