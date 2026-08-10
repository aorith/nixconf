{
  users.users.aorith.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      dates = "daily";
      flags = [
        "--all"
        "--volumes"
      ];
    };
  };
}
