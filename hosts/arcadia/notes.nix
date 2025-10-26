{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      notes = {
        autoStart = true;
        image = "dannyben/madness:1.2.4";
        ports = [
          "127.0.0.1:8323:3000"
        ];
        volumes = [ "/var/lib/syncthing/SYNC_STUFF/notes/zk/notes:/docs" ];
        cmd = [ "server" ];
      };
    };
  };
}
