{
  pkgs,
  pkgsFrom,
  ...
}: {
  home.packages =
    pkgs.lib.optionals pkgs.stdenv.isDarwin [
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgsFrom.unstable.wezterm
      pkgsFrom.unstable.alacritty
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [];
}
