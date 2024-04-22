{pkgs, ...}: {
  imports = [
    ../../../overlays
  ];

  config = {
    home.packages = [
      pkgs.tmux
    ];
  };
}
