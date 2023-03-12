{pkgs, ...}: {
  users.groups = {
    aorith = {
      members = ["aorith"];
      gid = 1000;
    };
  };
  users.users.aorith = {
    isNormalUser = true;
    uid = 1000;
    group = "aorith";
    description = "aorith";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.bash;
  };
}
