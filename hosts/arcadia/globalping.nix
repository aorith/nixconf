{ ... }:
{
  virtualisation.oci-containers.containers = {
    globalping-probe = {
      image = "docker.io/globalping/globalping-probe:latest";
      autoStart = true;
      extraOptions = [
        "--cap-drop=ALL"
        "--cap-add=NET_RAW"
        "--security-opt=no-new-privileges"
        "--pids-limit=256"
        "--memory=512m"
      ];
      environmentFiles = [ "/etc/globalping.env" ];
    };
  };
}
