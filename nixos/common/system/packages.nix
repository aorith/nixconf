{
  inputs,
  pkgs,
  pkgsFrom,
  ...
}: let
  python-packages = ps:
    with ps; [
      requests
    ];
in {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default

    (pkgs.lib.lowPrio inetutils) # telnet, lowPrio since it has some collisions (hostname, ...)
    #pkgs.pbcopy2 # overlay
    inputs.neovim-flake.packages.${pkgs.system}.default

    pkgsFrom.unstable.distrobox
    pkgsFrom.unstable.gitui
    pkgsFrom.unstable.tmux

    (pkgs.python3.withPackages python-packages)

    age
    alejandra
    ansible
    bat
    bc
    btop
    clang
    commonsCompress
    coreutils-full
    curl
    diffutils
    dig
    dstat
    efibootmgr
    fd
    ffmpeg-full
    file
    findutils
    fzf
    git
    glow
    gnumake
    gnused
    go
    gron
    htop
    imagemagick
    jq
    just
    killall
    kubectl
    lazygit
    libnotify # notify-send
    lsof
    minikube
    ncdu
    nil
    nmap
    nvd
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
    terraform
    tree
    unzip
    usbutils
    vim
    wget
    yq
  ];

  programs = {
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
