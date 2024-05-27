{pkgs, ...}: {
  imports = [
    ../../../overlays
  ];

  config = {
    home.packages = [
      pkgs.tmux
      pkgs.entr
    ];
  };
}
