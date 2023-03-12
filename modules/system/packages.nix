{
  pkgs,
  nixpkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bc
    clang
    fd
    git
    gnumake
    go
    python311
    ripgrep
    unstable.alejandra
    unstable.distrobox
    unstable.lazygit
    unstable.nil
    unstable.tmux
    vim
    wget
    tree
  ];

  programs.gnupg.agent.enable = true;
  programs.bash.enableCompletion = true;
}
