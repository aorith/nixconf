{
  services = {
    syncthing = {
      enable = true;
      guiAddress = "10.255.254.1:8384";
      # Disable: NAT Traversal, Global,Local Discovery and Relaying
      # Configure sync protocol on tcp4://10.255.254.1:22000 and point the other
      # devices to it instead of opening the ports here.
      openDefaultPorts = false; # 22000/tcp/udp, 21027/udp
    };
  };

  systemd.services.syncthing.unitConfig = {
    # This is to make sure that the service is started after I manually mount
    # the luks device after a restart of the system
    ConditionPathExists = "/var/lib/syncthing/luks-mounted";
  };
}
