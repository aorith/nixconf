{
  pkgs,
  pkgsFrom,
  ...
}: {
  imports = [
    ./nix.nix
    ./ssh.nix
    ./packages.nix
    ./python.nix
    ./shell-config.nix
    ./sysctl.nix
  ];

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  console.keyMap = "es";

  services.journald.extraConfig = ''
    SystemMaxUse=1G
  '';

  environment = {
    etc = {
      # Allow editing /etc/hosts as root (changes are disacarded on rebuild)
      hosts.mode = "0644";
    };
    shellAliases = let
      find = "${pkgs.findutils}/bin/find";
      fzf = "${pkgs.fzf}/bin/fzf";
      nvd = "${pkgsFrom.unstable.nvd}/bin/nvd";
    in {
      nixconf = "cd /home/aorith/githome/nixconf";
      #nix-list-packages = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u";
      nix-list-packages = "${nvd} list";
      nixos-diff = ''
        ${find} /nix/var/nix/profiles -maxdepth 1 -mindepth 1 -type l -name "*system-*link" | sort -Vr | ${fzf} | xargs -I {} ${nvd} diff {} /nix/var/nix/profiles/system
      '';
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
