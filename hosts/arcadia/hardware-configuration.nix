{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1ec14331-78eb-4574-b142-25cd602d5f42";
    fsType = "ext4";
    options = ["discard" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7560-612F";
    fsType = "vfat";
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
