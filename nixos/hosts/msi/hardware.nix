{
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.nixos-hardware.nixosModules.msi-gl62
    inputs.nixos-hardware.nixosModules.common-pc-hdd
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    tmpOnTmpfs = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    firewall.enable = true;
    enableIPv6 = false;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/51d97c89-b28a-463d-8dca-afc808d5138d";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/e624c3d0-1bd1-4e79-bc23-f4f01b652ffe";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/6D51-4274";
    fsType = "vfat";
  };

  swapDevices = [];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    video.hidpi.enable = lib.mkForce false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
