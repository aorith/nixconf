{...}: {
  imports = [
    ./nix.nix
    ./packages.nix
  ];

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console.keyMap = "es";

  services.journald.extraConfig = ''
    SystemMaxUse=900M
    MaxFileSec=7day
  '';

  environment = {
    etc = {
      # Allow editing /etc/hosts as root (changes are disacarded on rebuild)
      hosts.mode = "0644";
    };
    shellAliases = {
      nixconf = "cd /home/aorith/githome/nixconf";
      nix-list-packages = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u";
    };
  };
}
