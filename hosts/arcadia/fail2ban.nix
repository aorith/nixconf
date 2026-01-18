{ pkgs, lib, ... }:
{
  services.fail2ban = {
    enable = true;
    maxretry = 5; # By default ban IP after 5 failures
    ignoreIP = [
      # Whitelist some subnets
      "127.0.0.1"
      "172.17.0.0/16"
      "172.18.0.0/16"
      "10.255.254.0/24"
      "bree.iou.re" # resolve the IP via DNS
    ];
    bantime = "15m"; # First time ban time
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 4 32 128 512 1024 2048 4096 8192";
      maxtime = "30d"; # Do not ban for more than this time
      overalljails = true; # Calculate the bantime based on all the violations
    };

    jails = {
      sshd.settings = {
        enabled = true;
        action = lib.concatStringsSep "\n         " [
          "nftables-allports"
          "ntfy"
        ];
        maxretry = 3;
      };
      foticos.settings = {
        enabled = true;
        filter = "foticos";
        logpath = "/var/log/caddy/foticos.log";
        action = lib.concatStringsSep "\n         " [
          "nftables-allports"
          "ntfy"
        ];
        backend = "auto";
        maxretry = 5;
        findtime = 600;
      };
      portmon.settings = {
        enabled = true;
        filter = "portmon";
        backend = "systemd";
        journalmatch = "_TRANSPORT=kernel";
        action = lib.concatStringsSep "\n         " [
          "nftables-allports"
          "ntfy"
        ];
        maxretry = 1;
      };
    };
  };

  environment.etc = {
    # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
    "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        norestored = true
        actionban = ${pkgs.curl}/bin/curl -H "Title: [<name>] <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(${pkgs.hostname}/bin/hostname) after <failures> attempts." https://ntfy.sh/fail2ban-aorith
      ''
    );

    # fail2ban-regex --VD -d ',"ts":{Epoch}' /var/log/caddy/foticos.log '(?i)^.*"remote_ip":"<HOST>",.*,"uri":"/api/auth/login.*"status":401,.*$'
    # note: don't use '"ts":{Epoch},' with a comma after '{Epoch}', it expects epoch without decimals and caddy logs: ...,"ts":1734162061.2562792,...
    "fail2ban/filter.d/foticos.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        datepattern = ,"ts":{Epoch}
        failregex = (?i)^.*"remote_ip":"<ADDR>",.*,"uri":"/api/auth/login.*"status":401,.*$
      ''
    );

    "fail2ban/filter.d/portmon.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        failregex = ^.*PORTMON: .* SRC=<ADDR>.* DST=.*$
        journalmatch = _TRANSPORT=kernel
      ''
    );
  };
}
