{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.custom.system.sops {
    sops.age.keyFile = "/home/aorith/.config/sops/age/keys.txt";
    sops.age.generateKey = false;
    sops.defaultSopsFile = ./../../secrets/secrets.yaml;

    sops.secrets.root-hashedPassword = {
      sopsFile = ./../../secrets/users.yaml;
      neededForUsers = true;
    };
    sops.secrets.aorith-hashedPassword = {
      sopsFile = ./../../secrets/users.yaml;
      neededForUsers = true;
    };
  };
}
