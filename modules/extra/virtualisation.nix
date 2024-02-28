{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.spice-gtk
  ];

  users.users.aorith.extraGroups = [
    "docker"
    "libvirtd"
  ];

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      onBoot = "ignore";
      allowedBridges = ["br0" "virbr0"];
      qemu.ovmf.enable = true;
    };

    docker = {
      enable = true;
      autoPrune = {
        dates = "daily";
        flags = ["--all" "--volumes"];
      };
    };

    podman = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
