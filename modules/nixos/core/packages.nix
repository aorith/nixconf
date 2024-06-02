{
  lib,
  pkgs,
  unstable-pkgs,
  ...
}:
{
  imports = [ ./../../../overlays ];

  programs = {
    gnupg.agent.enable = true;
    htop.enable = true;
    iotop.enable = true;
    mtr.enable = true;
    traceroute.enable = true;
  };

  environment.systemPackages = with pkgs; [
    (lib.lowPrio inetutils) # telnet, lowPrio since it has some collisions (hostname, ...)
    bc
    dig
    fd
    file
    git
    git-lfs
    gnumake
    gnupg
    killall
    sops
    tmux
    tree
    unstable-pkgs.curl
    unstable-pkgs.jq
    unstable-pkgs.ripgrep
    unstable-pkgs.gotools
    wget
    wireguard-tools
  ];
}
