{
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc-hdd
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # https://nixos.wiki/wiki/Linux_kernel
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
    # AMD 1600:
    # BIOS: "power supply idle control" == "typical current idle"
    kernelParams = ["amd_iommu=on" "idle=nomwait" "rcu_nocbs=0-11"];
    kernelModules = ["kvm-amd" "amdgpu"];
    extraModulePackages = [];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = ["btrfs"];
    tmp.useTmpfs = true;
  };

  services.xserver.videoDrivers = ["amdgpu"];
  services.btrfs.autoScrub.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/ba2a6fe1-46f9-45aa-b42b-0fafa56e2c11";
    fsType = "btrfs";
    options = ["subvol=var" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B6FC-8DCC";
    fsType = "vfat";
  };

  fileSystems."/mnt/storage/tank" = {
    device = "/dev/disk/by-label/tank";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime"];
  };
  fileSystems."/mnt/storage/disk1" = {
    device = "/dev/disk/by-label/DISK1";
    fsType = "ext4";
    options = ["noatime"];
  };
  fileSystems."/mnt/storage/disk2" = {
    device = "/dev/disk/by-label/DISK2";
    fsType = "ext4";
    options = ["noatime"];
  };

  # bindmounts
  fileSystems."/home/aorith/storage/tank" = {
    device = "/mnt/storage/tank";
    options = ["bind" "rw"];
  };
  fileSystems."/home/aorith/storage/disk1" = {
    device = "/mnt/storage/disk1";
    options = ["bind" "rw"];
  };
  fileSystems."/home/aorith/storage/disk2" = {
    device = "/mnt/storage/disk2";
    options = ["bind" "rw"];
  };

  swapDevices = [];

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = false;
    enableIPv6 = false;
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  environment.systemPackages = with pkgs; [
    radeontop
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
