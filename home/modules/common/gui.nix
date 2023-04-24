{
  pkgs,
  pkgsFrom,
  ...
}: {
  home.packages =
    pkgs.lib.optionals pkgs.stdenv.isDarwin [
      # Darwin packages
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Linux packages
      pkgsFrom.unstable.wezterm
      pkgsFrom.unstable.alacritty
    ];
}
