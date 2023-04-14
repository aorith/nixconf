{...}: {
  services.openssh = {
    permitRootLogin = "prohibit-password";

    # disable IPv6
    listenAddresses = [
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
