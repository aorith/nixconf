{pkgs, ...}: {
  home.packages =
    pkgs.lib.optionals pkgs.stdenv.isDarwin [
      # Darwin packages
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Linux packages
      pkgs.alacritty
      pkgs.keepassxc
      pkgs.mpv
      pkgs.sublime4-dev
      pkgs.ungoogled-chromium
      pkgs.wezterm

      pkgs.wl-clipboard
      pkgs.xclip
      pkgs.xsel

      # Linux only fonts
      pkgs.cantarell-fonts
    ]
    ++ [
      # Common packages

      # Fonts
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
