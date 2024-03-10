{
  pkgs,
  lib,
  config,
  inputs,
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
      inputs.neovim-flake.packages.${pkgs.system}.default

      (python3.withPackages (py-pkgs: [
        py-pkgs.ipython
        py-pkgs.notebook
        py-pkgs.requests
      ]))

      gitFull
      riffdiff
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
      fd
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
      sops
      sysstat
      tree
      unzip
      usbutils
      wget
      wireguard-tools
      yq-go
    ];
  };
}
