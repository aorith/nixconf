{
  lib,
  pkgs,
  ...
}: let
  replace_docker_with_podman = false;
  with_libvirtd = true;
in {
  environment.systemPackages = [
    pkgs.virt-manager
    (lib.mkIf with_libvirtd pkgs.spice-gtk) # usb redirect
    (lib.mkIf replace_docker_with_podman pkgs.podman-compose)
  ];

  users.users.aorith.extraGroups = [
    (lib.mkIf (!replace_docker_with_podman) "docker")
    (lib.mkIf with_libvirtd "libvirtd")
  ];

  virtualisation = {
    spiceUSBRedirection.enable = with_libvirtd;
    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      onBoot = "ignore";
      allowedBridges = ["br0" "virbr0"];
      qemu.ovmf.enable = true;
    };

    docker = {
      enable = !replace_docker_with_podman;
      autoPrune = {
        dates = "daily";
        flags = ["--all" "--volumes"];
      };
    };

    podman = {
      enable = replace_docker_with_podman;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
