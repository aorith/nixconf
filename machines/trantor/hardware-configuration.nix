{
  config,
  lib,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd" "amdgpu"];
    extraModulePackages = [];
    tmpOnTmpfs = true;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  services.xserver.videoDrivers = ["amdgpu"];

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

  networking = {
    hostName = "trantor";
    hostId = "be6e2627"; # head -c8 /etc/machine-id
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
