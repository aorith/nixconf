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
    git
    gnumake
    go
    htop
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
    unstable.tmux
    usbutils
    vim
    wget
  ];

  programs.gnupg.agent.enable = true;
  programs.bash.enableCompletion = true;
}
