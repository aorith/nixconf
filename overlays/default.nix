{
  nixpkgs.overlays = [
    (import ./tmux)
  ];
}
