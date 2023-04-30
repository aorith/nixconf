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

    pkgs.alejandra
    pkgs.distrobox
    pkgs.lazygit
    pkgs.nil
    pkgs.nvd
    pkgs.terraform

    (pkgs.lib.lowPrio inetutils) # telnet, lowPrio since it has some collisions (hostname, ...)

    age
    bc
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
    fzf
    gnumake
    go
    jq
    killall
    kubectl
    lsof
    ncdu
    nvme-cli
    openssl
    openvpn
    p7zip
    parted
    pciutils
    pstree
    ripgrep
    smartmontools
    sysstat
    tree
    unzip
    usbutils
    vim
    wget
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
