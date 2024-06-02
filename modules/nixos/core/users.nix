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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx2MbdR3PwSOrBFAlv4F8W0gNCRUa23b+YmGgRuwFTb9BmspWZ6bqUFZhDmBBLZMIh+1iatg6ZOlZhFmbbzRMXO+X1AX79QuKeRLb7doIdPiLvSgYyydurQZNYvG9/IbfjwpxvAt9sce52ZIuHlea/NGvPqH1J7w5sm1OP/F4iGiAh46j+/ZYXlB7kvDxwwtOx+owLJIXwmPnTgytWzjdt3IbR8aXk4h/ZMlk2s2G9LMhKq+6p/vkgEcJL1eb7R5unk97A6tWDu6lPLagMEDX+ANudl2yaLzlMzyox2BcbLl95zaXrM0VkPynsW/biQufjXbs9HFjp1/h25XAHA2xWkpqEpWGUrWhjP42mt3B4Ai4ILgAppS0JkdU+Iudff662ird5cGgOCcZru7ckDPT7cltzEUz+U3QXRZJe+nd09+zBNfhtdagw3oeXPqilxv+oKG9dgl5yTOCksicpmo2vuqNR6y9jakkvTxqV+TudW3hkSejCtWBsijM1Kwr8Qp0= aorith"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmfktrz3eMNZ6aVJcvFC4ABOwMvS3g0gVuCAQKMwDSl aorith@msp"
    ];
  };
  users.users.root.hashedPasswordFile = config.sops.secrets.root-hashedPassword.path;
}
