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
    fzf
    git
    gnumake
    go
    htop
    python311
    ripgrep
    terraform
    tree
    unstable.alejandra
    unstable.distrobox
    unstable.lazygit
    unstable.nil
    unstable.tmux
    vim
    wget
  ];

  programs.gnupg.agent.enable = true;
  programs.bash.enableCompletion = true;
}
