{
  nixpkgs.overlays = [
    (import ./tmux)
  ];
}