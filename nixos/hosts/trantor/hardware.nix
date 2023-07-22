{
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}: let
  defaultBtrfsOpts = [
    "defaults"
    "compress=zstd"
    "noatime"
    "nodiscard" # instead use the fstrim timer
  ];
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc-hdd
  ];

  boot = {
    #kernelPackages = pkgs.linuxPackages_latest; # https://nixos.wiki/wiki/Linux_kernel
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
    # AMD 1600:
    # BIOS: "power supply idle control" == "typical current idle"
    kernelParams = ["amd_iommu=on" "iommu=pt" "idle=nomwait" "rcu_nocbs=0-11"];
    kernelModules = ["kvm-amd"];
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

  services.btrfs.autoScrub.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  fileSystems."/mnt/storage/tank" = {
    device = "/dev/disk/by-label/tank";
    fsType = "btrfs";
    options = defaultBtrfsOpts;
  };
  fileSystems."/mnt/storage/disk1" = {
    device = "/dev/disk/by-label/DISK1";
    fsType = "ext4";
    options = ["defaults" "noatime"];
  };
  fileSystems."/mnt/storage/disk2" = {
    device = "/dev/disk/by-label/DISK2";
    fsType = "ext4";
    options = ["defaults" "noatime"];
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
