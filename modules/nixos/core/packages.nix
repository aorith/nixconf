{
  lib,
  pkgs,
  unstable-pkgs,
  ...
}: {
  import = [
    ./../../../overlays
  ];

  config = {
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
      gnumake
      gnupg
      killall
      sops
      tmux
      tree
      unstable-pkgs.curl
      unstable-pkgs.jq
      unstable-pkgs.ripgrep
      wget
      wireguard-tools
    ];
  };
}
