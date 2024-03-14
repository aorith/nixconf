{
  inputs,
  pkgs,
  unstable-pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.neovim-flake.packages.${pkgs.system}.default

    (python3.withPackages (py-pkgs: [
      py-pkgs.ipython
      py-pkgs.notebook
      py-pkgs.requests
    ]))

    ansible
    ffmpeg-full
    unstable-pkgs.distrobox
    unstable-pkgs.go
    unstable-pkgs.terraform

    bat
    dstat
    fd
    ncdu
    nmap
    openssl
    openvpn
    p7zip
    parted
    pass
    pciutils
    sysstat
    unstable-pkgs.fzf
    unstable-pkgs.gron
    unstable-pkgs.riffdiff
    unstable-pkgs.yq-go
    unzip
    usbutils
  ];
}
