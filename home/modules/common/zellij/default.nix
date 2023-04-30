{pkgs, ...}: {
  programs.zellij.enable = true;
  # https://zellij.dev/documentation
  xdg.configFile."zellij/config.kdl".source = pkgs.substituteAll {
    src = ./config/zellij.kdl;
    copycmd = "${pkgs.pbcopy2}/bin/pbcopy2"; # defined in gui.nix
  };
}
