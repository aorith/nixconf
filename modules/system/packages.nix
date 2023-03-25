{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bc
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
    inetutils
    lsof
    nvme-cli
    openssl
    openvpn
    parted
    pciutils
    pstree
    ripgrep
    smartmontools
    sysstat
    terraform
    tree
    unstable.alejandra
    unstable.distrobox
    unstable.lazygit
    unstable.nil
    usbutils
    vim
    wget
  ];

  programs = {
    bash = {
      enableLsColors = true;
      enableCompletion = true;
    };
    tmux = {
      enable = true;
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
