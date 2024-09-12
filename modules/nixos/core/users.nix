{ config, ... }:
{
  users.mutableUsers = false;

  users.groups.aorith = {
    members = [ "aorith" ];
    gid = 1000;
  };
  users.users.aorith = {
    isNormalUser = true;
    uid = 1000;
    group = "aorith";
    description = "aorith";
    extraGroups = [
      "networkmanager"
      "wheel"
      "systemd-journal"
    ];
    linger = true;
    hashedPasswordFile = config.sops.secrets.aorith-hashedPassword.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmfktrz3eMNZ6aVJcvFC4ABOwMvS3g0gVuCAQKMwDSl aorith@msp"
    ];
  };
  users.users.root.hashedPasswordFile = config.sops.secrets.root-hashedPassword.path;
}
