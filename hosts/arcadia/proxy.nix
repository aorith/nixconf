{
  networking.firewall.allowedTCPPorts = [ 8888 ];
  services.tinyproxy = {
    enable = true;
    settings = {
      Port = 8888;
      Listen = "10.255.254.1";
      Allow = "10.255.254.0/24";
    };
  };
}
