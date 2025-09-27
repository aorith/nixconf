{
  services = {
    syncthing = {
      enable = true;
      guiAddress = "10.255.254.1:8384";
      openDefaultPorts = true; # 22000/tcp, 21027/udp
    };
  };

  systemd.services.syncthing.unitConfig = {
    # This is to make sure that the service is started after I manually mount
    # the luks device after a restart of the system
    ConditionPathExists = "/var/lib/syncthing/luks-mounted";
  };
}
