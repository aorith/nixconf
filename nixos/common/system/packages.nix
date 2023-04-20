{
  inputs,
  pkgs,
  pkgsFrom,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.neovim-flake.packages.${pkgs.system}.default

    pkgsFrom.unstable.alejandra
    pkgsFrom.unstable.distrobox
    pkgsFrom.unstable.lazygit
    pkgsFrom.unstable.nil
    pkgsFrom.unstable.nvd
    pkgsFrom.unstable.terraform

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
    inetutils # telnet
    jq
    just
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
    sops
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
