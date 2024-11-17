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
      "notes.iou.re" # resolve the IP via DNS
      "home.iou.re"
    ];
    bantime = "3d"; # First time ban time
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64 128 256";
      maxtime = "30d"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };

    jails = {
      sshd.settings = {
        enabled = true;
        action = lib.concatStringsSep "\n         " [
          ''iptables-multiport[name=SSH, port="22,22022"]''
          "ntfy"
        ];
        maxretry = 3;
      };
      caddy-notes.settings = {
        enabled = true;
        filter = "caddy-notes";
        logpath = "/var/log/caddy/notes.log";
        action = lib.concatStringsSep "\n         " [
          "iptables-allports"
          "ntfy"
        ];
        backend = "auto";
        maxretry = 5;
        findtime = 600;
      };
      caddy-notes-basic-auth.settings = {
        enabled = true;
        filter = "caddy-notes-basic-auth";
        logpath = "/var/log/caddy/notes.log";
        action = lib.concatStringsSep "\n         " [
          "iptables-allports"
          "ntfy"
        ];
        backend = "auto";
        maxretry = 5;
        findtime = 600;
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
    # Filter for notes access
    "fail2ban/filter.d/caddy-notes.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        datepattern = "ts":{Epoch},
        failregex = ^.*"remote_ip":"<HOST>",.*?auth\?error=1".*$
      ''
    );

    # fail2ban-regex --VD -d '"ts":{Epoch},' /var/log/caddy/notes.log '(?i)^.*"remote_ip":"<HOST>",.*?"Authorization".*"status":401,.*$'
    "fail2ban/filter.d/caddy-notes-basic-auth.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        datepattern = "ts":{Epoch},
        failregex = (?i)^.*"remote_ip":"<HOST>",.*?"Authorization".*"status":401,.*$
      ''
    );
  };
}
