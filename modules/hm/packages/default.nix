{
  inputs,
  pkgs,
  unstable-pkgs,
  ...
}: {
  imports = [
    ../../../overlays
  ];

  config = {
    home.packages = [
      pkgs.tmux
      pkgs.entr
      unstable-pkgs.nixfmt-rfc-style
      inputs.mynur.packages.${pkgs.system}.varnishlog-tui
    ];
  };
}
