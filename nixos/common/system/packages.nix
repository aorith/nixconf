{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default

    (pkgs.lib.lowPrio inetutils) # telnet, lowPrio since it has some collisions (hostname, ...)

    age
    btop
    clang
    commonsCompress
    coreutils-full
    dig
    dstat
    efibootmgr
    fd
    ffmpeg-full
    file
    go
    lsof
    ncdu
    nvme-cli
    openssl
    openvpn
    p7zip
    parted
    pciutils
    pstree
    smartmontools
    sysstat
    unzip
    usbutils
    vim
  ];

  programs = {
    bash = {
      enableLsColors = true;
      enableCompletion = true;
    };

    dconf.enable = true;
    git.enable = true;
    gnupg.agent.enable = true;
    htop.enable = true;
    iotop.enable = true;
    mtr.enable = true;
    traceroute.enable = true;
    wireshark.enable = true;
  };
}
