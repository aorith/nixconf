{
  services = {
    syncthing = {
      enable = true;
      user = "aorith";
      group = "aorith";
      dataDir = "/home/aorith/Syncthing";
      guiAddress = "10.255.255.8:8384";
      openDefaultPorts = false; # No FW
    };
  };
}
