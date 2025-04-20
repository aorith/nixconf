{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ 45340 ];
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    # Interface
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = [ "10.255.254.1/24" ];
      networkConfig = {
        IPMasquerade = "ipv4";
        IPv4Forwarding = true;
      };
    };
    # Netdev & Peers
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/etc/wireguard-keys/wg0.key";
          ListenPort = 45340;
        };
        wireguardPeers = [
          {
            # Trantor
            PublicKey = "qpJpTU8yDNyuCZ9kjolGDMA/Wz25BM5NReieARaWyVI=";
            AllowedIPs = [ "10.255.254.7/32" ];
            PersistentKeepalive = 15;
            PresharedKeyFile = "/etc/wireguard-keys/wg0.psk";
          }
          {
            # Phone
            PublicKey = "TbRB49Gl1WY5aLDbAyZEzLg+wHRq2Sul/CDYxqfvDU8=";
            AllowedIPs = [ "10.255.254.3/32" ];
            PersistentKeepalive = 15;
            PresharedKeyFile = "/etc/wireguard-keys/wg0.psk";
          }
        ];
      };
    };
  };
}
