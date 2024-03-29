{
  config,
  lib,
  ...
}: let
  btrfsList = builtins.attrValues (lib.filterAttrs (name: fs: fs.fsType == "btrfs") config.fileSystems);
  hasBtrfs = builtins.length btrfsList > 0;
in {
  services.btrfs.autoScrub.enable = hasBtrfs;
  # The default already maps all the btrfs fs.mountPoints
  #services.btrfs.autoScrub.fileSystems
}
