{
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  time.hardwareClockInLocalTime = true; # Dual boot

  services.xserver.videoDrivers = ["amdgpu"];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  services.btrfs.autoScrub.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fd3f9eb4-5fa6-4f63-99ac-0dce636f4134";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime" "nodiscard"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/fd3f9eb4-5fa6-4f63-99ac-0dce636f4134";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime" "nodiscard"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/fd3f9eb4-5fa6-4f63-99ac-0dce636f4134";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime" "nodiscard"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/fd3f9eb4-5fa6-4f63-99ac-0dce636f4134";
    fsType = "btrfs";
    options = ["subvol=log" "compress=zstd" "noatime" "nodiscard"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/49321409-da41-4eb4-a246-c4a9f9eed48f";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B8C5-C13A";
    fsType = "vfat";
  };

  fileSystems."/mnt/storage/tank" = {
    device = "/dev/disk/by-label/TANK";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime" "nodiscard"];
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

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
