{
  lib,
  pkgs,
  unstable-pkgs,
  inputs,
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
    entr # Run arbitrary commands when files change (don't remember which program required it)
    fd
    file
    git
    git-lfs
    gnumake
    gnupg
    inputs.mynur.packages.${pkgs.system}.varnishlog-tui
    killall
    sops
    tmux
    tmux # from overlays
    tree
    unstable-pkgs.curl
    unstable-pkgs.fzf
    unstable-pkgs.gotools
    unstable-pkgs.jq
    unstable-pkgs.nixfmt-rfc-style
    unstable-pkgs.ripgrep
    wget
    wireguard-tools
  ];
}
