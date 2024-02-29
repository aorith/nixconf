{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.custom.system.packages {
    programs = {
      gnupg.agent.enable = true;
      htop.enable = true;
      iotop.enable = true;
      mtr.enable = true;
      traceroute.enable = true;
      wireshark.enable = true;
    };

    environment.systemPackages = with pkgs; [
      (python3.withPackages (py-pkgs: [
        py-pkgs.ipython
        py-pkgs.notebook
        py-pkgs.requests
      ]))

      vim
      gitFull
      tmux

      ansible
      distrobox
      ffmpeg-full
      go
      terraform

      # Basic cmdline tools
      (lib.lowPrio inetutils) # telnet, lowPrio since it has some collisions (hostname, ...)
      bat
      bc
      commonsCompress
      curl
      dig
      dstat
      file
      fzf
      gnumake
      gnupg
      gron
      jq
      killall
      ncdu
      nmap
      openssl
      openvpn
      p7zip
      parted
      pass
      pciutils
      ripgrep
      sysstat
      tree
      unzip
      usbutils
      wget
      wireguard-tools
      yq
    ];
  };
}
