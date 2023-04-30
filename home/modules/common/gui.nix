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
      pkgsFrom.unstable.mpv
      pkgsFrom.unstable.ungoogled-chromium
      pkgsFrom.unstable.sublime4

      pkgs.imagemagick
      pkgs.wl-clipboard
      pkgs.xclip
      pkgs.xsel

      pkgs.pbcopy2 # overlay
    ]
    ++ [
      # Common packages
    ];
}
