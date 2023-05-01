{...}: {
  imports = [
    ./home.nix
    ./shell-config.nix
    ./git.nix
    ./gui.nix
    ./tmux
    ./zellij
  ];
}
