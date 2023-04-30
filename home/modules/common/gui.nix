{pkgs, ...}: {
  home.packages =
    pkgs.lib.optionals pkgs.stdenv.isDarwin [
      # Darwin packages
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Linux packages
      pkgs.wezterm
      pkgs.alacritty
      pkgs.mpv
      pkgs.ungoogled-chromium
      pkgs.sublime4

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
