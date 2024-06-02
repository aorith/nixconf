{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.age.keyFile = "/home/aorith/.config/sops/age/keys.txt";
  sops.age.generateKey = false;
  sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";

  sops.secrets.root-hashedPassword = {
    sopsFile = "${inputs.self}/secrets/users.yaml";
    neededForUsers = true;
  };
  sops.secrets.aorith-hashedPassword = {
    sopsFile = "${inputs.self}/secrets/users.yaml";
    neededForUsers = true;
  };
}
