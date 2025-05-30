{ inputs, pkgs, ... }:
let
  tls-cert =
    {
      alt ? [ ],
    }:
    (pkgs.runCommand "selfSignedCert" { buildInputs = [ pkgs.openssl ]; } ''
      mkdir -p $out
      openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 -days 365 -nodes \
        -keyout $out/cert.key -out $out/cert.crt \
        -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,${
          builtins.concatStringsSep "," ([ "IP:127.0.0.1" ] ++ alt)
        }"
    '');
in
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    defaultListen = [
      {
        addr = "127.0.0.1";
        port = 8000;
        ssl = false;
      }
      {
        addr = "10.255.254.1";
        port = 7676;
        ssl = true;
      }
    ];
    virtualHosts = {
      notes =
        let
          cert = tls-cert { alt = [ "IP:10.255.254.1" ]; };
        in
        {
          serverName = "_";
          default = true;
          forceSSL = true;
          sslCertificate = "${cert}/cert.crt";
          sslCertificateKey = "${cert}/cert.key";
          locations."/".proxyPass = "http://10.255.254.1:3000/";
        };
    };
  };
}
