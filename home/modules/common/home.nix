{
  inputs,
  pkgs,
  ...
}: let
  python-pkgs = p:
    with p; [
      requests
      urllib3
    ];
in {
  fonts.fontconfig.enable = true;
  xdg.mime.enable = pkgs.stdenv.isLinux;

  home.packages = with pkgs;
    [
      # Common packages
      (pkgs.lib.lowPrio inetutils) # telnet, lowPrio since it has some collisions (hostname, ...)
      pkgs.pbcopy2 # overlay
      inputs.neovim-flake.packages.${pkgs.system}.default

      (python3.withPackages python-pkgs)

      ansible
      bc
      curl
      diffutils
      fd
      findutils
      git
      glow
      gnumake
      gnused
      gron
      imagemagick
      just
      killall
      kubectl
      lazygit
      minikube
      nmap
      ripgrep
      terraform
      tree
      wget
      yq
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      # Darwin packages
      bashInteractive
      coreutils-full
      mtr
      vim
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Linux packages
      alejandra
      distrobox
      nil
      nvd
    ];

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = false;
      defaultCommand = "fd --type f --follow --exclude .git";
    };
    bat.enable = true;
    jq.enable = true;
    less.enable = true;
    lesspipe.enable = true;
    man.enable = true;
    gpg.enable = true;

    htop.enable = pkgs.stdenv.isDarwin;
  };
}
