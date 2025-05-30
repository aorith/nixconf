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
        addr = "10.255.254.1";
        port = 7676;
        ssl = true;
      }
    ];
    virtualHosts = {
      somehost =
        let
          cert = tls-cert { alt = [ "IP:10.255.254.1" ]; };
        in
        {
          serverName = "someserver";
          sslCertificate = "${cert}/cert.crt";
          sslCertificateKey = "${cert}/cert.key";
          forceSSL = true;
          locations."/".proxyPass = "http://10.255.254.1:3000/";
        };
    };
  };
}
