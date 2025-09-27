{
  services = {
    syncthing = {
      enable = true;
      guiAddress = "10.255.254.1:8384";
      openDefaultPorts = true; # 22000/tcp, 21027/udp
    };
  };
}
