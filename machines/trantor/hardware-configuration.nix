{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "amdgpu"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cf410a4d-08f3-4026-bbcf-537c3d4194f7";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/367D-7052";
    fsType = "vfat";
  };

  fileSystems."/home/aorith/storage/tank" = {
    device = "/dev/disk/by-label/tank";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime"];
  };
  fileSystems."/home/aorith/storage/disk1" = {
    device = "/dev/disk/by-label/DISK1";
    fsType = "ext4";
    options = ["noatime"];
  };
  fileSystems."/home/aorith/storage/disk2" = {
    device = "/dev/disk/by-label/DISK2";
    fsType = "ext4";
    options = ["noatime"];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
