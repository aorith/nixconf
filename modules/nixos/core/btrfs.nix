{ config, lib, ... }:
let
  # [ { "/dev/disk/by-uuid/fd3f9eb4-5fa6-4f63-99ac-0dce636f4134" = "/"; } ... ]
  btrfsDevices = lib.mapAttrsToList (name: fs: { "${fs.device}" = fs.mountPoint; }) (
    lib.filterAttrs (name: fs: fs.fsType == "btrfs") config.fileSystems
  );
  # [ "/mnt/storage/tank" "/" ]
  btrfsList = lib.attrValues (lib.attrsets.mergeAttrsList (lib.lists.reverseList btrfsDevices));

  hasBtrfs = builtins.length btrfsList > 0;
in
{
  services.btrfs.autoScrub.enable = hasBtrfs;
  services.btrfs.autoScrub.fileSystems = btrfsList;
}
