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

      pkgs.wl-clipboard
      pkgs.xclip
      pkgs.xsel
    ]
    ++ [
      # Common packages


      pkgs.cantarell-fonts
      pkgs.dejavu_fonts
      pkgs.hack-font
      pkgs.jetbrains-mono
      pkgs.liberation_ttf
      pkgs.libertine
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-emoji
      (pkgs.nerdfonts.override {fonts = ["Hack" "JetBrainsMono"];})
    ];
}
