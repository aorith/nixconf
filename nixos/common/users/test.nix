{pkgs, ...}: {
  users.groups = {
    test = {
      members = ["test"];
      gid = 1234;
    };
  };
  users.users.test = {
    isNormalUser = true;
    uid = 1234;
    group = "test";
    description = "test user";
    extraGroups = ["systemd-journal"];
    shell = pkgs.bash;
  };
}
