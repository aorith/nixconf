{lib, ...}: {
  services.openssh = {
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };

    # disable IPv6
    listenAddresses = lib.mkDefault [
      {
        addr = "0.0.0.0";
        port = 22;
      }
    ];

    # disable RSA
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
