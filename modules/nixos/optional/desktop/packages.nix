{
  inputs,
  pkgs,
  unstable-pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (python3.withPackages (py-pkgs: [
      py-pkgs.ipython
      py-pkgs.notebook
      py-pkgs.requests
    ]))

    inputs.neovim-flake.packages.${pkgs.system}.nvim-without-config

    ansible
    ffmpeg-full
    unstable-pkgs.distrobox
    unstable-pkgs.go
    unstable-pkgs.terraform
    opentofu

    bat
    dool # dstat
    fd
    gh
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
    unstable-pkgs.kubectl
    unstable-pkgs.riffdiff
    unstable-pkgs.yq-go
    unzip
    usbutils
  ];
}
