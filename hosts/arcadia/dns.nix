# To override DNS configure this in the [interface] section of
# the wireguard client config:
# DNS = 10.255.254.1

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "10.255.254.1" ];
        access-control = [ "10.255.254.0/24 allow" ];
        local-data = [
          ''"www.example.com. IN A 10.255.255.5"''
          ''"test.example.com IN A 10.255.255.1"''
        ];

        # Skip DNSSEC
        domain-insecure = [ "example.com" ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "8.8.8.8@853#dns.google"
            "8.8.4.4"
          ];
        }
        {
          name = "ifconfig.io.";
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }
      ];
    };
  };
}
