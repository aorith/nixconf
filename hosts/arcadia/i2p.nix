{
  services.i2pd = {
    enable = true;
    port = 9205;
    proto = {
      http.enable = false;
      sam.enable = false;
      bob.enable = false;
      i2cp.enable = false;
      httpProxy.enable = false;
      socksProxy.enable = false;
      i2pControl.enable = false;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 9205 ];
    allowedUDPPorts = [ 9205 ];
  };
}
