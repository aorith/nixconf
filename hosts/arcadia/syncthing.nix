{
  networking.firewall = {
    # https://docs.syncthing.net/users/firewall.html#local-firewall
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [
      21027
      22000
    ];
  };

  services = {
    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
    };
  };
}
