{
  lib,
  pkgs,
  ...
}: let
  with_podman = true;
  with_libvirtd = true;
in {
  environment.systemPackages = [
    pkgs.virt-manager
    (lib.mkIf with_podman pkgs.podman-compose)
  ];

  users.users.aorith.extraGroups = [
    (lib.mkIf (!with_podman) "docker")
    (lib.mkIf with_libvirtd "libvirtd")
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      onBoot = "ignore";
      allowedBridges = ["br0" "virbr0"];
      qemu.ovmf.enable = true;
    };

    docker = {
      enable = !with_podman;
      storageDriver = "btrfs";
      autoPrune = {
        dates = "daily";
        flags = ["--all" "--volumes"];
      };
    };

    podman = {
      enable = with_podman;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
