{
  config,
  pkgs,
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
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [];
    tmpOnTmpfs = true;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = [ "btrfs" ];
  };

  services.xserver.videoDrivers = ["amdgpu"];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
      fsType = "btrfs";
      options = [ "subvol=var" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B6FC-8DCC";
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
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
