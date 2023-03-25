{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    virt-manager
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
      enable = true;
      storageDriver = "btrfs";
      autoPrune = {
        dates = "daily";
        flags = ["--all" "--volumes"];
      };
    };
  };
}
