{ ... }:
{
  virtualisation.oci-containers.containers = {
    varnishlog_parser = {
      image = "ghcr.io/aorith/varnishlog-parser:latest";
      autoStart = true;
      ports = [ "127.0.0.1:8080:8080" ];
    };
  };
}
